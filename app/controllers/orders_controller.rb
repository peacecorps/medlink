class OrdersController < ApplicationController
  def index
    @orders = current_user.accessible_orders.order "orders.created_at desc"
  end

  def manage
    authorize! :manage, Order
    @orders = current_user.accessible_orders
  end

  def new
    @order = current_user.orders.new location: current_user.location
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
      next_page = case current_user.role.to_sym
      when :admin
        new_admin_user_path
      when :pcmo
        manage_orders_path
      else
        orders_path
      end

      # Tag P6
      redirect_to next_page,
        notice: "Success! The Order you placed on behalf of " +
          "#{@order.user.name} has been sent."
    else
      render :new
    end
  end

  private # -----

  def create_params
    params.require(:order).permit [:extra, :supply_id, :location,
                                   :dose, :quantity, :user_id]
  end
end

