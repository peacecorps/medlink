class ReportsController < ApplicationController
  def index
    authorize! :report, Order
  end

  def order_history
    authorize! :report, Order
    @orders = current_user.accessible Order
  end

  def users
    authorize! :report, User
    @users = User.all
  end

  def pcmo_response_times
    authorize! :report, User
    @orders = current_user.accessible Order
  end
end
