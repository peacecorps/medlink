class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  skip_before_filter :authenticate_user!, only: :help

  rescue_from CanCan::AccessDenied do |exception|
    # It'd be nice to redirect to the login page in case the user wants to
    #   sign in with another (authorized) account. Devise redirects logged
    #   in users away from that page, however, and clobbers the flash message
    #   in the process.
    redirect_to root_path, flash: { error: I18n.t!("flash.auth.general") }
  end

  def root
    redirect_to start_page
  end

  def help
    render 'partials/help'
  end

  def active_country_id
    return unless current_user
    current_user.admin? ? session[:active_country_id] : current_user.country_id
  end
  def active_country?
    active_country_id.present?
  end
  helper_method :active_country_id, :active_country?

  private # ----------

  def start_page
    if current_user.admin?
      new_admin_user_path
    elsif current_user.pcmo?
      manage_orders_path
    else
      new_request_path
    end
  end

  # Redirects to the login path to allow the flash messages to
  #    display for sign_out.
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
