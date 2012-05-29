# encoding: utf-8
# == Schema Information
#
# Table name: keyword_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class KeywordCategory < ActiveRecord::Base
  has_many :keywords
  accepts_nested_attributes_for :keywords

  validates :name, :presence => true

  attr_accessible :name

  def self.skills
    KeywordCategory.where(name: 'Pôles de compétence').first
  end
end
