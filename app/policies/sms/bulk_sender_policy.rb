class SMS
  class BulkSenderPolicy < ApplicationPolicy
    def create?
      user.admin?
    end
  end
end
