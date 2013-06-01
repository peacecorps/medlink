class RequestsController < ApplicationController
  respond_to :json

  def create
    @request = Request.new params[:request].slice(*attributes)
    if @request.save
      render json: {success: true, request: @request}
    else
      render :status => :unacceptable, json: {errors: @request.errors, success: false}
    end
  end

  def destroy
    r = Request.where(id: params[:id]).first!
    r.destroy
    render json: {success: true}
  end

  def update
    r = Request.where(id: params[:id]).first!
    r.update_attributes params[:request].slice(*attributes)
    render json: {success: true}
  end

  protected

  def attributes
    Request.column_names.map(&:to_sym)
  end
end
