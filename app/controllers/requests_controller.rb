class RequestsController < ApplicationController
  respond_to :json

  def create
    attributes = params.slice(
      :dose, :location, :quantity, :state, :supply_id, :user_id,
      :phone, :email
    )
    @request = Request.new(attributes)
    if @request.save
      render json: {success: true}
    else
      render json: {errors: @request.errors, success: false}
    end
  end

  def destroy
  end

  def update
  end
end
