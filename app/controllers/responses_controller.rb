class ResponsesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :initialize_response

  def new
  end

  def create
    @response.update_attributes response_params
    if @response.save
      @response.send!
      # Tag P6
      redirect_to manage_orders_path, notice: "Success! Your response" +
        "has been sent to #{@order.user.name} #{@order.user.pcv_id}." +
        "This request will now appear in the response tracker awaiting " +
        "fullment."
    else
      render :new
    end
  end

  private # -----

  def initialize_response
    @order = current_user.accessible_orders.find params[:order_id]
    authorize! :manage, @order
    @response = Response.new order: @order
  end

  def response_params
    params.require(:response).permit [:delivery_method, :instructions]
  end
end

