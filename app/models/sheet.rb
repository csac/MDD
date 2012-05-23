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

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
  end

  def historize(user, action='create')
    History.create(
      subject: self,
      action: action,
      user: user
    )
  end

  # Search

  mapping do
    indexes :id,          type: :integer, index: :not_analyzed
    indexes :title,       type: :string,  analyzer: :keyword
    indexes :description, type: :string,  analyzer: :keyword
    indexes :up_to_date,  type: :boolean, index: :not_analyzed
  end

  def to_indexed_json
    {
      id:          self.id,
      title:       self.title,
      description: self.description,
      up_to_date:  self.up_to_date
    }.to_json
  end

  def self.search(params = {})
    s = Tire::Search::Search.new(tire.index.name, load: true)

    # Query
    if params[:query].present?
      s.query { string params[:query] }
    else
      s.query { all }
    end

    s.filter :term, {up_to_date: params[:up_to_date]} if params[:up_to_date].present?

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
    skills = KeywordCategory.where(name: 'Pôles de compétence').first
    # Check if any keyword belongs to the skills category
    unless self.keywords.any? { |keyword| skills.keywords.include?(keyword) }
      errors.add(:keywords, I18n.t("errors.one_skill_keyword"))
    end
  end

end
