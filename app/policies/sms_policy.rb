class SMSPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope
      else
        scope.includes(:user).where(users: { country_id: user.country_id })
      end
    end
  end
end
