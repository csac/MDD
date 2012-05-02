# encoding: utf-8
class Sheet < ActiveRecord::Base
  has_and_belongs_to_many :keywords
  accepts_nested_attributes_for :keywords

  validates :title,       :presence => true
  validates :description, :presence => true
  validates :level,       :presence => true
  validate  :at_least_one_keyword

  attr_accessible :title, :description, :level, :up_to_date, :keyword_ids

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
  end

  private

  def at_least_one_keyword
    errors.add(:keywords, "There must have at least one keyword") if self.keywords.size == 0
  end

end
