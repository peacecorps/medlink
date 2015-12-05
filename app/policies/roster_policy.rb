class RosterPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def show?
    if user.admin?
      true
    elsif user.pcmo?
      record == :roster || record.country_id == user.country_id
    else
      false
    end
  end
end

