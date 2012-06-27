# encoding: utf-8
# == Schema Information
#
# Table name: sheets
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  level       :integer
#  up_to_date  :boolean
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Sheet < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  LEVELS = [1, 2, 3]

  has_and_belongs_to_many :keywords
  has_many   :histories, dependent: :destroy, as: :subject

  accepts_nested_attributes_for :keywords

  validates :title,       presence: true
  validates :description, presence: true
  validates :level,       presence: true, inclusion: { in: LEVELS }
  validate  :at_least_one_skills_keyword

  attr_accessible :title, :description, :level, :up_to_date, :keyword_ids

  # Search

  mapping do
    indexes :id,          type: :integer, index: :not_analyzed
    indexes :title,       type: :string,  analyzer: :french
    indexes :description, type: :string,  analyzer: :french
    indexes :up_to_date,  type: :boolean, index: :not_analyzed
    indexes :level,       type: :integer, index: :not_analyzed
    indexes :updated_at,  type: :date,    index: :not_analyzed
    indexes :tags,        type: :string,  index: :not_analyzed
  end

  def to_indexed_json
    {
      id:          self.id,
      title:       self.title,
      description: self.description,
      up_to_date:  self.up_to_date,
      level:       self.level,
      updated_at:  self.updated_at,
      tags:        self.keywords.map(&:name)
    }.to_json
  end

  def self.search(params = {})
    s = Tire::Search::Search.new(tire.index.name, load: true)

    # Query
    if params[:query].present?

      # Fix bad queries
      params[:query] = params[:query].split().map { |q| q.end_with?(':') ? q.chomp(':') : q }.join(' ')

      s.query { string params[:query] }
    else
      s.query { all }
    end

    # Filters
    [:up_to_date, :level].each do |term|
      s.filter :term, {term => params[term]} if params[term].present?
    end

    # Tags
    tags = Array(params[:tags]) + Array(params['most-used-keywords'])
    s.filter :and, tags.map { |tag| {term: {tags: tag}} } if tags.present?

    # Date
    case params[:updated]
    when 'today'
      s.filter :range, updated_at: {gte: Date.today, lt: Date.tomorrow}
    when 'yesterday'
      s.filter :range, updated_at: {gte: Date.yesterday, lt: Date.today}
    when 'this-week'
      s.filter :range, updated_at: {gte: Date.today.beginning_of_week, lt: Date.tomorrow}
    when 'this-month'
      s.filter :range, updated_at: {gte: Date.today.beginning_of_month, lt: Date.tomorrow}
    end

    # Facets
    s.facet 'tags', global: true do
      terms :tags, exclude: KeywordCategory.skills.keywords.map(&:name)
    end

    # Pagination
    if params[:pagination] != false
      s.from params[:page] ? (params[:page].to_i - 1) : 0
      s.size params[:per_page] || Kaminari.config.default_per_page
    end

    s.sort { by params[:sort_by] || :updated_at, :desc}

    s
  end

  def self.clear_index!
    self.tire.index.delete
    self.tire.index.create mappings: self.tire.mapping_to_hash, settings: self.tire.settings
  end

  def self.refresh_index!
    self.tire.index.refresh
  end

  private

  def at_least_one_skills_keyword
    # Check if any keyword belongs to the skills category
    unless self.keywords.any? { |keyword| KeywordCategory.skills.keywords.include?(keyword) }
      errors.add(:keywords, I18n.t("errors.one_skill_keyword"))
    end
  end

end
