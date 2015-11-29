class ReportPolicy < ApplicationPolicy
  def download?
    if record.authorizer
      record.authorizer.call user
    else
      user.pcmo? || user.admin?
    end
  end
end
