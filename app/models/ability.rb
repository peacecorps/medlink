class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.pcv?
      can :create, Request, user_id: user.id

    elsif user.pcmo?
      can :respond, User, country_id: user.country_id
      can :manage, Order, country_id: user.country_id
      can :manage, Request, country_id: user.country_id

    elsif user.admin?
      can :manage, User
      can :manage, Order
      can :manage, Request
      can :manage, CountrySupply
    else
      raise "Can't check authorization for unknown role (#{user.role})"
    end
  end
end

