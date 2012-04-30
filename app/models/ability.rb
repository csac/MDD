class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :administrator
      can :manage, :all
    elsif user.has_role? :author
      can :manage, Sheet
    end

  end
end
