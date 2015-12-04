class RosterPolicy < ApplicationPolicy
  def show?
    user.admin? || (user.pcmo? && user.country == record.country)
  end
end
