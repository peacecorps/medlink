class AdminController < ApplicationController
  before_action :verify_access

  def verify_access
    unless current_user.try :admin?
      redirect_to root_url, :flash => { :error => 'You must be an admin to view that page' }
    end
  end
end
