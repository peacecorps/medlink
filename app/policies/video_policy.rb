class VideoPolicy < ApplicationPolicy
  def show?
    update?
  end

  def update?
    user == record.viewer
  end
end
