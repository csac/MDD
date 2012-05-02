# encoding: utf-8
# == Schema Information
#
# Table name: keywords
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  keyword_category_id :integer
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class Keyword < ActiveRecord::Base
  belongs_to :keyword_category
  has_and_belongs_to_many :sheets

  validates :name,             :presence => true
  validates :keyword_category, :presence => true

  attr_accessible :name, :keyword_category, :keyword_category_id
end
