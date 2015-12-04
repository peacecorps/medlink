class ResponsePolicy < ApplicationPolicy
  def mark_received?
    record.user_id == user.id || country_admin?
  end

  def flag?
    admin? || country_admin? || record.user_id == user.id
  end

  def cancel?
    country_admin?
  end

  def reorder?
    country_admin?
  end
end
