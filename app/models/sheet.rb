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
  LEVELS = [1, 2, 3]

  has_and_belongs_to_many :keywords
  accepts_nested_attributes_for :keywords

  validates :title,       presence: true
  validates :description, presence: true
  validates :level,       presence: true, inclusion: { in: LEVELS }
  validate  :at_least_one_keyword

  attr_accessible :title, :description, :level, :up_to_date, :keyword_ids

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
  end

  private

  def at_least_one_keyword
    if self.keywords.blank?
      errors.add(:keywords, "There must have at least one keyword")
    end
  end

end
