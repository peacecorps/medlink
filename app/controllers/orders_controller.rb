class OrdersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json
  respond_to :csv, only: :index

  def index
    @orders = current_user.accessible_orders.all
    respond_with @orders
  end

  def show
    order_id = params[:order_id] || params[:id]
    respond_with current_user.accessible_orders.where(id: order_id).first!
  end

  def create
    order = Order.new(params[:order])
    order.user = current_user
    if order.save
      render json: {success: true, order: order}
    else
      render :status => :unacceptable, json: {errors: order.errors}
    end
  end

  def update
    order = current_user.accessible_orders.where(
      id: params[:order_id] || params[:id]).first!
    if order.update_attributes(params[:order])
      order.send_instructions!
      render json: {success: true, order: order}
    else
      render :status => :unacceptable, json:
        {success: false, errors: order.errors}
    end
  end

  def destroy
    order = current_user.accessible_orders.where(
      id: params[:order_id] || params[:id]).first!
    order.destroy
    render json: {success: true}
  end
end
