class MessageSenderPolicy < ApplicationPolicy
  def new?
    user && !user.pcv?
  end

  def send?
    if user.admin?
      true
    elsif user.pcmo?
      record.country_ids == [user.country_id]
    else
      false
    end
  end
end
