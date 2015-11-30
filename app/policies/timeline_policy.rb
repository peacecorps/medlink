class TimelinePolicy < ApplicationPolicy
  def show?
    user == record.user || country_admin?
  end
end
