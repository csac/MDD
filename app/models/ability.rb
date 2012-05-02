# encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :administrator
      can :manage, :all
    elsif user.has_role? :author
      can [:edit, :update, :show, :edit_password, :update_password], user
      can :manage, Sheet
    end

  end
end
