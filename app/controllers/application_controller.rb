class ApplicationController < ActionController::Base
  protect_from_forgery

  def root
    authenticate_user!
    render 'layouts/index'
  end

  def about
    render 'layouts/about'
  end

  def help
    render 'layouts/help'
  end
end
