# encoding: UTF-8
Fabricator(:keyword, class_name: :keyword) do
  name { Faker::Name.name }
  keyword_category { Fabricate(:keyword_category) }
end
