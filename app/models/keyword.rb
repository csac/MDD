# encoding: utf-8
class Keyword < ActiveRecord::Base
  belongs_to :keyword_category
  has_and_belongs_to_many :sheets
  attr_accessible :name, :keyword_category, :keyword_category_id
end
