class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.pcmo? || user.admin?
      can :manage, Order
    end

    if user.admin?
      can :manage, User
    end
  end
end

