class RequestsController < ApplicationController

  def new
    @request = current_user.requests.new
    @request.orders.new
  end

  def create
    @request = Request.new create_params
    @request.entered_by = current_user.id
    @request.orders.each do |o|
      o.request = @request
      o.user    = @request.user
    end

    if @request.user_id
      authorize! :create, @request
    end

    if @request.save
      next_page = if current_user.admin?
        new_admin_user_path
      elsif current_user.pcmo?
        manage_orders_path
      else
        orders_path
      end

      redirect_to next_page, flash: {
        success: I18n.t!("flash.request_placed_for", username: @request.user.name) }
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:request).permit :user_id, :body,
      orders_attributes: [:supply_id]
  end
end
