class SupplyPolicy < ApplicationPolicy
  def manage_master_supply_list?
    user.admin?
  end
end