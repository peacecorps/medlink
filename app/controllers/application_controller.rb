class ApplicationController < ActionController::Base
  protect_from_forgery

  def root
    render 'layouts/index'
  end
end
