class User < ActiveRecord::Base
  include RoleModel

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :firstname, :lastname
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :roles, :roles_mask

  roles_attribute :roles_mask
  roles :administrator, :author
end
