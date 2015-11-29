class AnnouncementPolicy < ApplicationPolicy
  def index?
    user.pcmo? || user.admin?
  end

  def deliver?
    country_admin?
  end

  def destroy?
    admin?
  end

  def schedule?
    admin?
  end
end
