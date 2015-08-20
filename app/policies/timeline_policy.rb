class TimelinePolicy < ApplicationPolicy
  def country_id
    record.user.country_id
  end

  def show?
    user == record.user || country_admin?
  end
end
