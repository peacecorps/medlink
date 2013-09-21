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
      if current_user.try(:pcv?)
        # Tag P6
        redirect_to another_orders_path, notice: "Success! The Order you placed on behalf of #{@order.user.first_name} #{@order.user.last_name} has been sent."
      else # PCMO or ADMIN
        # Tag P6
        redirect_to orders_path, notice: "Success! The Order you placed on behalf of #{@order.user.first_name} #{@order.user.last_name} has been sent."
      end
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
    # FIXME: limit to admins
    # FIXME: currently, this *can't* fail any validations. Should we check for instructions here?
    # FIXME: should we always send instructions on an update?
    @order.update_attributes update_params.merge(responded_at: Time.now)
    @order.send_instructions!
    # Tag P6
    redirect_to manage_orders_path, notice: "Success! Your response has been sent to #{@order.user.first_name} #{@order.user.last_name} #{@order.user.pcv_id}. This request will now appear in the response tracker awaiting fullment."
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
