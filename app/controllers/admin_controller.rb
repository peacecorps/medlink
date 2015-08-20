class AdminController < ApplicationController
  before_action :verify_access
  skip_after_action :verify_authorized

  def verify_access
    unless current_user && current_user.admin?
      redirect_to root_url, flash: { error: I18n.t!("flash.auth.admin") }
    end
  end
end
