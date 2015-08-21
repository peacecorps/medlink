class MessagePolicy < ApplicationPolicy
  def index?
    user.pcmo? || user.admin?
  end
end
