class AdminPolicy < ApplicationPolicy
  def manage?
    user.admin?
  end
end
