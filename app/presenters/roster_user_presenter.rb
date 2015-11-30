class RosterUserPresenter < ApplicationPresenter
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

  def phone_list
    list_of phones.map { |p| h.phone_link(p) }
  end
end
