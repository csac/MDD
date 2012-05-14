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
  has_many   :histories, dependent: :destroy, as: :historyable

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

  private

  def at_least_one_skills_keyword
    skills = KeywordCategory.where(name: 'Pôles de compétence').first
    # Check if any keyword belongs to the skills category
    unless self.keywords.any? { |keyword| skills.keywords.include?(keyword) }
      errors.add(:keywords, I18n.t("errors.one_skill_keyword"))
    end
  end

end
