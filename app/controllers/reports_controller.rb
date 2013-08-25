class ReportsController < ApplicationController
  def index
  end

  def request_history
    @orders = current_user.accessible_orders
  end

  def fulfillment_history
    @orders = current_user.accessible_orders
  end

  def recent_adds
    #@users = User.all
    @users = User.where("created_at >= ?", 1.month.ago)
  end

  def recent_edits
    @users = User.all.order("updated_at DESC")
  end

  def pcmo_response_times
    @orders = Order.group(Order.user_id.pcmo_id).all
  end

  def supply_history
    @supplies = Supply.all
  end
end
