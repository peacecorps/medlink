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

private

  def sort_table scope, **opts
    @_sort_table_registry ||= SortTable::Registry.new
    @_sort_table_registry.build scope, opts.merge(params: params)
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

  def validate reform, *args
    reform.validate(*args).tap { authorize reform }
  end

  # :nocov:
  def alert_if_slow
    start = Time.now
    yield
    duration = Time.now - start
    if duration > 1.second
      message = "#{params[:controller]}##{params[:action]} took #{duration} (#{request.path})"
      Rails.configuration.slackbot.info message if ENV["ALERT_IF_SLOW"]
      Rails.logger.info message
    end
  end
  # :nocov:
end
