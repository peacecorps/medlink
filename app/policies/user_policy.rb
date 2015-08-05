class UserPolicy < ApplicationPolicy
  def respond?
    # A headless policy is asking if we can respond to _some_ user
    admin? || \
    (user.pcmo? && record == :user) || \
    country_pcmo?
  end

  def report?
    admin?
  end
end
