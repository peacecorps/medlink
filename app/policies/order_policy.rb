class OrderPolicy < ApplicationPolicy
  def report?
    !user.pcv?
  end
end
