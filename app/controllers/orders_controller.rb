class OrdersController < ApplicationController
  def index
    @orders = current_user.accessible_orders
  end

  def manage
    authorize! :manage, Order
    @orders = current_user.accessible_orders
  end

  def new
    # FIXME: need "Add Another Supply" functionality for PCVs
    @order = current_user.orders.new location: current_user.location
  end

  def create
    @order = Order.new create_params.merge entered_by: current_user
    authorize! :create, @order

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
                                   :unit, :quantity, :user_id]
  end
end

