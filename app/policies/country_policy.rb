class CountryPolicy < ApplicationPolicy
  def country_id
    record.id
  end

  def manage_supplies?
    country_admin?
  end
end
