# encoding: utf-8
Fabricator(:user, class_name: :user) do
  firstname         { Faker::Name.name }
  lastname          { Faker::Name.name }
  email             { Faker::Internet.email }
  password          'password'
  roles             { [:administrator, :author].sample }
end

Fabricator(:author, from: :user) do
  roles             { :author }
end

Fabricator(:administrator, from: :user) do
  roles             { :administrator }
end

Fabricator(:producer, from: :user) do
  roles             { :producer }
end

