class ResponsePolicy < ApplicationPolicy
  def mark_received?
    record.user_id == user.id || (user.pcmo? && user.country_id == record.user.country_id)
  end
  def flag?
    record.user_id == user.id
  end
end
