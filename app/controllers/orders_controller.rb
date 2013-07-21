class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order, except: [:index, :new, :create]

  def index
    @orders = current_user.accessible_orders
  end

  def new
    @order = current_user.orders.new
  end

  def create
    @order = current_user.orders.new order_params
    if @order.save
      redirect_to orders_path, notice: "Order submitted successfully"
    end
  end

  def edit
    # FIXME: limit to admins
  end

  def update
    # FIXME: fix. limit to admins
    raise
    flash[:notice] = "Order updated successfully" if @order.save
    # FIXME: determine when to send instructions
    @order.send_instructions
  end

  private # -----

  def find_order
    @order = current_user.accessible_orders.find params[:id]
  end

  def order_params
    params.require(:order).permit :request_attributes, :extra
  end
end
