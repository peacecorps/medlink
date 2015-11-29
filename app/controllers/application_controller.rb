class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :authenticate_user!
  after_action :verify_authorized, except: :index, unless: :devise_controller?

  around_action :alert_if_slow

  include Pundit
  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to new_user_session_path, flash: { error: exception }
  end

  private

  def after_sign_out_path_for _
    new_user_session_path
  end

  def after_sign_in_path_for user
    if user.welcome_video_seen?
      root_path
    else
      welcome_video_user_path
    end
  end

  def sort_table scope, **opts
    @_sort_table_registry ||= SortTable::Registry.new
    @_sort_table_registry.build scope, opts.merge(params: params)
  end

  def save_form reform, *args
    valid = reform.validate *args
    authorize reform
    reform.save if valid
    valid
  end

  def skip_bullet
    #Bullet.enable = false
    yield
  ensure
    Bullet.enable = true
  end

  def alert_if_slow
    start = Time.now
    yield
    duration = Time.now - start
    if duration > Rails.configuration.slow_timeout.seconds
      Notification.send :slow, "#{params[:controller]}##{params[:action]} took #{duration} (#{request.path})"
    end
  end
end
