class ResponsePolicy < ApplicationPolicy
  def mark_received?
    record.user_id == user.id || country_pcmo? || admin?
  end

  def flag?
    record.user_id == user.id
  end

  def cancel?
    country_pcmo? || admin?
  end

  def reorder?
    country_pcmo? || admin?
  end
end
