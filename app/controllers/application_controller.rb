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
    redirect_to orders_path
  end

  def help
    render 'partials/help'
  end
end
