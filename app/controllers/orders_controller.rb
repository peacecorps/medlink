class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order, except: [:index, :new, :create, :report, :manage]

  def index
    @orders = current_user.accessible_orders
  end

  def manage
    @orders = current_user.accessible_orders
  end

  def new
    @order = current_user.orders.new location: current_user.location
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
      'Delivery' => 'Your request is estimated to arrive at your location on ' +
        'this date [enter date here].',
      'Pickup' => 'Please pick up your request at this [enter location here] ' +
        'by this [enter date]',
      'Purchase & Reimburse' => 'We do not have your requested item in ' +
        'stock. Please purchase elsewhere and allow us to reimburse you.',
      'Special Instructions' => 'Please contact me at this [phone number] ' +
        'concerning your request.'
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
    params.require(:order).permit [:extra, :supply_id, :location,
                                   :unit, :quantity]
  end

  def update_params
    params.require(:order).permit [:instructions]
  end
end
