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
    @order = current_user.orders.new create_params
    if @order.save
      redirect_to orders_path, notice: "Order submitted successfully"
    else
      render :new
    end
  end

  def edit
    @defaults = {
      'Delivered to PCV' => 'Please pick up your request at ' +
        '[enter location here] by [enter date here].',
      'PCV Purchase' => 'We do not have your requested item in stock. ' +
        'Please purchase elsewhere and allow us to reimburse you.',
      'Delivered to Hub' => 'Your request is estimated to arrive ' +
        'at your location on [enter date here].',
      'Special Instructions' => ''
    }
  end

  def update
    # FIXME:
    # - limit to admins
    # - currently, this *can't* fail any validations. Should we check for
    #     instructions here?
    # - should we always send instructions on an update?
    @order.update_attributes update_params.merge(fulfilled_at: Time.now)
    @order.send_instructions!
    redirect_to orders_path, notice: "Order updated successfully"
  end

  private # -----

  def find_order
    @order = current_user.accessible_orders.find params[:id]
  end

  def create_params
    params.require(:order).permit [:extra, :supply_id, :dose, :unit, :quantity]
  end

  def update_params
    params.require(:order).permit [:instructions]
  end
end
