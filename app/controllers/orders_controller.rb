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
    clean! params[:order]

    @order = current_user.orders.new create_params
    if @order.save!
      redirect_to orders_path, notice: "Order submitted successfully"
    else
      # FIXME: validation messages
      render :new
    end
  end

  def edit
  end

  def update
    # FIXME: fix. limit to admins?
    raise
    flash[:notice] = "Order updated successfully" if @order.save
    # FIXME: determine when to send instructions
    @order.send_instructions
  end

  private # -----

  def find_order
    @order = current_user.accessible_orders.find params[:id]
  end

  def clean! order
    req = order[:requests_attributes]
    req[:supply_id] = Supply.lookup(req[:supply_id]).id
    req[:dose] = "#{req.delete :dosage}#{req.delete :unit}"
    order[:requests_attributes] = [req]
  end

  def create_params
    params.require(:order).permit :extra,
      requests_attributes: [:supply_id, :dose, :quantity]
  end

  def update_params
    params.require(:order)
  end
end
