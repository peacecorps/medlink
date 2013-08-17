class ReportController < ApplicationController
  def request_history
    @orders = current_user.accessible_orders
  end

  def fulfillment_history
    @orders = current_user.accessible_orders
  end

  def recent_adds
    @users = User.all
    # User.where("updated_at >= :start_date AND updated_at <= :end_date",
                #{start_date: params[:start_date], end_date: params[:end_date]})
  end

  def recent_edits
    @users = User.all
  end

  def pcmo_response_times
  end

  def supply_history
    @supplies = Supply.all
  end
end
