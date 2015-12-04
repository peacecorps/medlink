class RosterUploadPolicy < ApplicationPolicy
  def create?
    admin?
  end

  def poll?
    record.uploader_id == user.id
  end
end
