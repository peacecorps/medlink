class RosterUserPresenter < Draper::Decorator
  decorates User
  delegate_all

  def role
    if pcv?
      "PCV ##{pcv_id}"
    elsif pcmo?
      "PCMO"
    else
      "Admin"
    end
  end
end
