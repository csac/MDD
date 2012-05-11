# encoding: UTF-8
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

Fabricator(:sheet, class_name: :sheet) do
  title Faker::Name.name
  description Faker::Lorem.paragraph
  level Sheet::LEVELS.sample
  keywords! { [ Fabricate(:skill_keyword) ] }
end
