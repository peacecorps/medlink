class SuppliesController < ApplicationController
  before_action do
    authorize :supply, :manage_master_supply_list?
  end

  def index
    @supplies = Supply.unscoped.all.order name: :asc
  end

  def new
    @supply = Supply.new
  end

  def create
    @supply = Supply.new(supplies_params)
    if @supply.save
      redirect_to supplies_path
    else
      render :new
    end
  end

  def toggle_orderable
    supply = Supply.unscoped.find params[:id]
    supply.toggle!(:orderable)
    redirect_to :back
  end

  private

  def supplies_params
    params.require(:supply).permit(:shortcode, :name)
  end
end
