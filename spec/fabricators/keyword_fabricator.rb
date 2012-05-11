# encoding: UTF-8
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

Fabricator(:keyword, class_name: :keyword) do
  name { Faker::Name.name }
  keyword_category { Fabricate(:keyword_category) }
end

Fabricator(:skill_keyword, from: :keyword) do
  keyword_category! { Fabricate(:keyword_category, name: 'Pôles de compétence') }
end

