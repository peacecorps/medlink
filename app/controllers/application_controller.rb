class ApplicationController < ActionController::Base
  protect_from_forgery

  def root
    authenticate_user!
    render 'layouts/index'
  end
end
