class Keyword < ActiveRecord::Base
  belongs_to :keyword_category
  attr_accessible :name, :keyword_category, :keyword_category_id
end
