class MessagePolicy < ApplicationPolicy
  def index?
    user.pcmo? || user.admin?
  end

  def tester?
    test?
  end

  def test?
    user.admin?
  end
end
