class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :authenticate_user!
  after_action :verify_authorized, except: :index, unless: :devise_controller?

  around_action :alert_if_slow

  include Pundit
  rescue_from Pundit::NotAuthorizedError do |exception|
    # It'd be nice to redirect to the login page in case the user wants to
    #   sign in with another (authorized) account. Devise redirects logged
    #   in users away from that page, however, and clobbers the flash message
    #   in the process.
    redirect_to root_path, flash: { error: I18n.t!("flash.auth.general") }
  end
  rescue_from Pundit::AuthorizationNotPerformedError do |ex|
    # :nocov:
    Slackbot.new.message "#{ex.to_s} - #{controller_action_name}"
    # :nocov:
  end if Rails.env.production?

private

  def sort_table scope, opts={}
    opts[:params] = params
    SortTable.new scope, opts
  end

  # Redirects to the login path to allow the flash messages to
  #    display for sign_out.
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(user)
    if user.welcome_video_seen?
      root_path
    else
      welcome_video_user_path
    end
  end

  def skip_bullet
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = true
  end

  # :nocov:
  def alert_if_slow
    start = Time.now
    yield
    duration = Time.now - start
    if duration > 1.second
      Slackbot.new.message "#{controller_action_name} took #{duration} (#{request.path})"
    end
  end

  def controller_action_name
    "#{params[:controller]}##{params[:action]}"
  end
  # :nocov:
end
