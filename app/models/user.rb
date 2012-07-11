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

class User < ActiveRecord::Base
  include RoleModel

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable
  # and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :firstname, :lastname
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :roles, :roles_mask

  validates :roles_mask, presence: true
  validate :at_least_one_role

  roles_attribute :roles_mask
  roles :administrator, :author

  has_many :histories, dependent: :destroy, as: :subject

  def name
    if firstname && lastname
      "#{firstname} #{lastname}"
    else
      email.split('@').first
    end
  end

  def administrator?
    has_role? :administrator
  end

  private
  def at_least_one_role
    errors.add(:roles, I18n.t('errors.missing_role')) if self.roles.empty?
  end
end
