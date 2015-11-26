class RosterUploadPolicy < ApplicationPolicy
  def create?
    admin?
  end
end
