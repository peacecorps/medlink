class UserPolicy < ApplicationPolicy
  def update?
    admin? || country_pcmo?
  end

  def respond?
    return true if user.admin?
    return false unless user.pcmo?
    # A headless policy is asking if we can respond to _some_ user
    record == :user || record.country_id == user.country_id
  end

  def inactivate?
    admin? && record.id != user.id
  end

  def set_country?
    admin? && record.id == user.id
  end
end
