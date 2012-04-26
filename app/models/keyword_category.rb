class KeywordCategory < ActiveRecord::Base
  has_many :keywords
  accepts_nested_attributes_for :keywords

  attr_accessible :name
end
