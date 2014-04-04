class OrdersController < ApplicationController
  def index
    @orders = accessible_orders.order "orders.created_at desc"
  end

  def manage
    authorize! :respond, User
    @orders = accessible_orders
    @responses = visible_responses
  end

  def new
    @order = current_user.orders.new
  end

  def create
    @order = Order.new create_params.merge entered_by: current_user

    if @order.user_id
      authorize! :create, @order
    else
      # Not enough info to authorize; redisplay with validation errors
      @order.valid?
      render :new and return
    end

    if @order.save
      next_page = if current_user.admin?
        new_admin_user_path
      elsif current_user.pcmo?
        manage_orders_path
      else
        orders_path
      end

      redirect_to next_page, flash: {
        success: Medlink.translate(
          "flash.order_placed_for", username: @order.user.name) }
    else
      render :new
    end
  end

  private # -----

  def create_params
    params.require(:order).permit [:extra, :supply_id, :location, :user_id]
  end

  def accessible_orders
    current_user.accessible_orders.includes :user, :supply
  end

  def visible_responses
    current_user.visible_responses
  end
end
