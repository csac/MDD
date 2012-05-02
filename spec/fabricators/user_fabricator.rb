# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)
#  password               :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  roles_mask             :integer
#

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

