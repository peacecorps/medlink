class CountryPolicy < ApplicationPolicy
  def manage_master_supply_list?
    if user.admin?
      true
    end
  end
end