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
    if current_user.nil? || current_user.pcv?
      render 'partials/help'
    else
      render 'partials/pcmo_help'
    end
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

  def sort_column prefix=nil
    sort = params["#{prefix}sort"]
    User.column_names.include?(sort) ? sort : "waiting_since"
  end
  helper_method :sort_column

  def sort_direction prefix=nil
    dir = params["#{prefix}direction"]
    %w(asc desc).include?(dir) ? dir.to_sym : :asc
  end
  helper_method :sort_direction

  # Redirects to the login path to allow the flash messages to
  #    display for sign_out.
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  # Customizes path after login to show welcome_video if first login
  def after_sign_in_path_for(user) 
    if current_user.welcome_video_seen?
      root_path  
    else
      welcome_video_user_path
    end
  end
end
