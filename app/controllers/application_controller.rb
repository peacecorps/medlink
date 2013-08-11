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
require 'ipaddr'

class ApplicationController < ActionController::Base
  protect_from_forgery

  # before_action :check_ip_for_admins

  def root
    redirect_to orders_path
  end

  def help
    render 'partials/help'
  end

  private # ----------

  def ip_allowed?
    request_ip  = IPAddr.new request.remote_ip
    Rails.configuration.allowed_ips.any? do |addr|
      IPAddr.new(addr).include? request_ip
    end
  end

  def check_ip_for_admins
    if current_user && current_user.admin?
      if !ip_allowed?
        sign_out current_user
        redirect_to new_user_session_path,
          notice: 'Admin users may only login from approved ip addresses'
      end
    end
  end
end
