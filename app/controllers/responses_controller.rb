class ResponsesController < ApplicationController
  before_filter :initialize_response, only: [:new, :create]
  before_filter :find_response, only: [:show, :archive]

  def new
    @orders = @user.orders.without_responses.
      includes(:request, :supply)
    @history = @user.orders.with_responses.
      includes(:supply).
      page(params[:page])
  end

  def create
    @response.update_attributes(response_params) || raise("Failed to update response")
    orders = params[:orders].select { |_,data| data.include? "delivery_method" }
    Order.where(id: orders.keys).includes(:request, :user, :country, :supply).each do |o|
      data = orders[o.id.to_s].merge response_id: @response.id
      o.update_attributes data.permit :delivery_method, :response_id
    end
    @response.include_updated_orders!
    @response.send!
    redirect_to manage_orders_path, flash:
      { success: I18n.t!("flash.response_sent", user: @user.name) }
  end

  def show
  end

  def archive
    @response.archive!
    redirect_to manage_orders_path, flash:
      { success: I18n.t!("flash.response_archived") }
  end

  private # -----

  def initialize_response
    @user = User.find params[:user_id]
    authorize! :respond, @user
    @response = Response.new user: @user
  end

  def find_response
    id = params[:response_id] || params[:id]
    @response = Response.find id
    @user     = @response.user
    authorize! :respond, @user
  end

  def response_params
    params.require(:response).permit :extra_text
  end
end
