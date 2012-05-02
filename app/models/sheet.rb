# encoding: utf-8
class Sheet < ActiveRecord::Base
  has_and_belongs_to_many :keywords
  accepts_nested_attributes_for :keywords

  attr_accessible :title, :description, :level, :up_to_date, :keyword_ids

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
  end

end
