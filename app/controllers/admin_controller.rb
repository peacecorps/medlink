class AdminController < ApplicationController
  before_action :verify_access

  def verify_access
    unless current_user && current_user.admin?
      redirect_to root_url, flash: { error:
        Medlink.translate("flash.auth.admin") }
    end
  end
end
