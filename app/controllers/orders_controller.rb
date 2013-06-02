class OrdersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    respond_with current_user.accessible_orders.all
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
    order = current_user.accessible_orders.where(id: params[:order_id] || params[:id]).first!
    if order.update_attributes(params[:order])
      render json: {success: true, order: order}
    else
      render :status => :unacceptable, json: {success: false, errors: order.errors}
    end
  end
  
  def destroy
    order = current_user.accessible_orders.where(id: params[:order_id] || params[:id]).first!
    order.destroy
    render json: {success: true}
  end
end
