# encoding: UTF-8
# == Schema Information
#
# Table name: keyword_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

Fabricator(:keyword_category, class_name: :keyword_category) do
  name { Faker::Name.name }
end
