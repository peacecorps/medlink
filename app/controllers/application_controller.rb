class ApplicationController < ActionController::Base
  protect_from_forgery

  def root
    authenticate_user!
    if current_user.try(:admin?)
      start_page = new_admin_user_path
    elsif current_user.try(:pcmo?)
      start_page = manage_orders_path
    else # PCV
      start_page = orders_path
    end
    redirect_to start_page
  end

  def help
    render 'partials/help'
  end

  private # ----------

  # Redirects to the login path to allow the flash messages to
  #    display for sign_out.
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
