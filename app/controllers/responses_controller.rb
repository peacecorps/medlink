class ResponsesController < ApplicationController
  before_filter :initialize_response, except: [:show]

  def new
    @orders = @user.orders.without_responses.
      order("orders.created_at DESC").
      includes(:supply)
    @history = @user.orders.with_responses.
      order("orders.created_at DESC").
      includes(:supply).
      page(params[:page]).
      per 10
  end

  def create
    if @response.update_attributes response_params
      orders = params[:orders].select { |_,data| data.include? "delivery_method" }
      Order.find(orders.keys).each do |o|
        data = orders[o.id.to_s].merge response_id: @response.id
        o.update_attributes data.permit :delivery_method, :response_id
      end
      @response.send!
      redirect_to manage_orders_path, flash:
        { success: Medlink.translate("flash.response_sent", user: @user.to_s) }
    else
      render :new
    end
  end

  def show
    @response = Response.find params[:id]
    @user     = @response.user
    authorize! :response, @user
  end

  private # -----

  def initialize_response
    @user = User.find params[:user_id]
    authorize! :respond, @user
    @response = Response.new user: @user
  end

  def response_params
    params.require(:response).permit :extra_text
  end
end
