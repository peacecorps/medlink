class User
  class UploadPolicy < ApplicationPolicy
    def run?
      user.admin?
    end
  end
end
