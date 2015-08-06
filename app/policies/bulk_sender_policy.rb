class BulkSenderPolicy < ApplicationPolicy
  def index?
    update?
  end
end