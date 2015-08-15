class ResponsePolicy < ApplicationPolicy
  def mark_received?
    record.user_id == user.id
  end
  def flag?
    record.user_id == user.id
  end
end
