class RequestPolicy < ApplicationPolicy
  def new?
    record.entered_by == user.id
  end

  def create?
    if user.pcv?
      record.user_id == user.id && record.entered_by == user.id
    else
      record.entered_by == user.id
    end
  end
end
