class CountryPolicy < ApplicationPolicy
  def manage_supplies?
    if user.admin?
      true
    elsif user.pcmo?
      record.id == user.country_id
    else
      false
    end
  end
end
