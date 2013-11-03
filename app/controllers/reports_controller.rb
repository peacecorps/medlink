class ReportsController < ApplicationController

  before_action :verify_access

  def index
  end

  def order_history
    @orders = current_user.accessible_orders
  end

  def users
    @users = User.all
  end

  def pcmo_response_history
    @users = User.all
  end

  private

  def verify_access
    unless current_user.admin? || current_user.pcmo?
      redirect_to root_url, notice: 'You must be an admin or pcmo to view that page'
    end
  end

end
