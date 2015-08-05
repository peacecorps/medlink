class VideoPolicy < ApplicationPolicy
  def show?
    if user.pcv?
      record == Video::PCV_WELCOME
    else
      record == Video::PCMO_WELCOME
    end
  end
end
