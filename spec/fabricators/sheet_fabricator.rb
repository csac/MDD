# encoding: UTF-8
Fabricator(:sheet, class_name: :sheet) do
  title Faker::Name.name
  description Faker::Lorem.paragraph
  level Sheet::LEVELS.sample
  keywords { [ Fabricate(:keyword) ] }
end
