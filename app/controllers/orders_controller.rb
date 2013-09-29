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
      nextpage = orders_path
      if current_user.try(:admin?)
        nextpage = new_admin_user_path
      elsif current_user.try(:pcmo?)
        nextpage = manage_orders_path
      else # current_user.try(:pcv?)
        #FIXME: Need to add "Another Supply" web page. -- current_user.try(:pcv?)
        nextpage = orders_path
      end
      # Tag P6
      redirect_to nextpage,
        notice: "Success! The Order you placed on behalf of " +
          "#{@order.user.first_name.humanize} " +
          "#{@order.user.last_name.humanize} has been sent."
    else
      render :new
    end
  end

  def edit
  end

  def update
    # FIXME: limit to admins
    # FIXME: currently, this *can't* fail any validations. Should we
    # check for instructions here?
    # FIXME: should we always send instructions on an update?
    @order.update_attributes update_params.merge(responded_at: Time.now)
    @order.send_instructions!
    # Tag P6
    redirect_to manage_orders_path, notice: "Success! Your response " +
      "has been sent to #{@order.user.first_name} #{@order.user.last_name} " +
      "#{@order.user.pcv_id}. This request will now appear in the " +
      "response tracker awaiting fullment."
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
    params.require(:order).permit [:delivery_method, :instructions]
  end
end
