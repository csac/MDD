# encoding: utf-8
class KeywordCategory < ActiveRecord::Base
  has_many :keywords
  accepts_nested_attributes_for :keywords

  validates :name, :presence => true

  attr_accessible :name
end
