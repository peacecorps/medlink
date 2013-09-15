# FIXME: add devise messages
# registration edit
#   Successfully updated your profile.
#   There was a problem with your profile.
# registration create
#   Welcome! Please sign in with your new account.
#   There was a problem with your information.
# session destroy
#   You have been successfully signed out.
# session new
#   Invalid email or password.
class ApplicationController < ActionController::Base
  protect_from_forgery

  def root
    authenticate_user!
    start_page = current_user.try(:admin?) ? new_admin_user_path : manage_orders_path
    redirect_to start_page
  end

  def help
    render 'partials/help'
  end

  private # ----------

  # Redirects to the login path to allow the flash messages to display for sign_out.
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
