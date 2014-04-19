class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.pcv?
      can :create, Order, user_id: user.id

    elsif user.pcmo?
      can :respond, User, country_id: user.country_id
      can :manage, Order do |order|
        order.user.country_id == user.country_id
      end

    elsif user.admin?
      can :manage, User
      can :manage, Order

    else
      raise "Can't check authorization for unknown role (#{user.role})"
    end
  end
end

