class ReportsController < ApplicationController

  before_action :verify_access

  def index
  end

  def request_history
    @orders = current_user.accessible_orders
  end

  def fulfillment_history
    @orders = current_user.accessible_orders.where('fulfilled_at IS NOT NULL')
  end

  def recent_adds
    #@users = User.all
    @users = User.where("created_at >= ?", 1.month.ago)
  end

  def recent_edits
    @users = User.where("updated_at >= ?", 1.month.ago)
  end

  def pcmo_response_times
    @orders = Order.group(Order.user_id.pcmo_id).all
  end

  def supply_history
    @orders = Order.order("supplies.name").joins(:supply).select(
      "orders.*, supplies.name as supply_name")
  end

  private

  def verify_access
    unless current_user.try( :pcmo? ) || current_user.try( :admin? )
      redirect_to root_url,
        notice: 'You must be an pcmo or admin to view that page'
    end
  end

end
