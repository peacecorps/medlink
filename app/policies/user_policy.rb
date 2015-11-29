class UserPolicy < ApplicationPolicy
  def update?
    super || record.id == user.id
  end

  def respond?
    # A headless policy is asking if we can respond to _some_ user
    admin? || \
    (user.pcmo? && record == :user) || \
    country_pcmo?
  end

  def report?
    admin?
  end

  def inactivate?
    admin? && record.id != user.id
  end

  def set_country?
    admin? && record.id == user.id
  end
end
