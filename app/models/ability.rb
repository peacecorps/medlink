class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    case user.role
    when "pcv"
      can :create, Order, user_id: user.id

    when "pcmo"
      can :manage, Order, user: { country_id: user.country_id }

    when "admin"
      can :manage, User
      can :manage, Order

    else
      raise "Can't check authorization for unknown role (#{user.role})"
    end
  end
end

