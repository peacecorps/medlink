class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    # TODO: it'd be nice to redirect to the login page in case the user wants to
    #   sign in with another (authorized) account. Devise redirects logged in users
    #   away from that page, however, and clobbers the flash message in the process.
    redirect_to root_path, notice: 'You are not authorized to view that page'
  end

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
