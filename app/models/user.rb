# encoding: utf-8
class User < ActiveRecord::Base
  include RoleModel

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable
  # and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :firstname, :lastname
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :roles, :roles_mask

  validates :roles_mask, presence: true
  validate :at_least_one_role

  roles_attribute :roles_mask
  roles :administrator, :author

  def administrator?
    has_role? :administrator
  end

  private
  def at_least_one_role
    errors.add(:roles, I18n.t('errors.missing_role')) if self.roles.empty?
  end
end
