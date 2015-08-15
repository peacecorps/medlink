class TimelinePolicy < ApplicationPolicy
  def show?
    user.admin? || \
      (user.pcmo? && user.country_id == record.user.country_id) || \
      user == record.user
  end
end
