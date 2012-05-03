class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: :true

  validates :subject, presence: true
  validates :user, presence: true
  validates :action, presence: true
end
