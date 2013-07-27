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
    if @order.save
      redirect_to orders_path, notice: "Order submitted successfully"
    else
      # FIXME: validation messages
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
    @order.update_attributes update_params
    @order.send_instructions!
    redirect_to orders_path, notice: "Order updated successfully"
  end

  private # -----

  def find_order
    @order = current_user.accessible_orders.find params[:id]
  end

  def clean! order
    return order unless req = order[:requests_attributes]
    req[:supply_id] = Supply.lookup(req[:supply_id]).id rescue nil
    req[:dose] = "#{req.delete :dosage}#{req.delete :unit}"
    order[:requests_attributes] = [req]
  end

  def create_params
    params.require(:order).permit :extra,
      requests_attributes: [:supply_id, :dose, :quantity]
  end

  def update_params
    params.require(:order).permit [:fulfilled, :instructions]
  end
end
