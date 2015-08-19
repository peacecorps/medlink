class SuppliesController < ApplicationController

  def index
    @supplies = Supply.all
    authorize @supplies, :manage_master_supply_list?
  end

  #Show might not be necessary
  def show
    @supply = Supply.find params[:id]
    authorize @supply, :manage_master_supply_list?
  end

  def new
    supply = Supply.new
    authorize supply, :manage_master_supply_list?
  end

  def create
    supply = Supply.create!(supplies_params)
    authorize supply, :manage_master_supply_list?
  end

  def edit
    supply = Supply.find params[:id]
    authorize supply, :manage_master_supply_list?
  end

  def update
    supply = Supply.find params[:id]
    authorize supply, :manage_master_supply_list?
  end

  def not_available
    supply = Supply.find params[:id]
    authorize supply, :manage_master_supply_list?
    # Hide, do not destroy item.  Must add 'Available' column to Supply Schema.

    supply.update(available: false)
    if supply.save
  end

  private

  def supplies_params
    params.require(:supply).permit(:shortcode, :name)
  end

end