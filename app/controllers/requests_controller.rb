class RequestsController < ApplicationController

  def new
    @request = current_user.requests.new
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

    if @request.orders.any?
      @request.save!
      @request.user.mark_updated_orders
      redirect_to after_create_page, flash: { success: create_success_message }
    else
      flash[:error] = I18n.t! "flash.request_empty"
      render :new
    end
  end

  private

  def create_params
    p = params.require(:request).permit :user_id, :text,
      orders_attributes: [:supply_id]
    p[:orders_attributes].reject! { |_,ps| ps[:supply_id].empty? }
    p
  end

  def after_create_page
    if current_user.admin?
      new_admin_user_path
    elsif current_user.pcmo?
      manage_orders_path
    else
      orders_path
    end
  end

  def create_success_message
    if @request.user_id == @request.entered_by
      I18n.t! "flash.request_placed"
    else
      I18n.t! "flash.request_placed_for", username: @request.user.name
    end
  end
end
