class SuppliesController < ApplicationController
  before_action do
    authorize :supply, :manage_master_supply_list?
  end

  def index
    @supplies = Supply.all.order(name: :asc)
  end

  def create
    supply = Supply.new(params.require(:supply).permit :shortcode, :name)
    if supply.save
      # TODO: should this be on or off for countries by default?
      render json: supply
    else
      head :invalid
    end
  end

  def toggle_orderable
    supply = Supply.find params[:id]
    supply.toggle!(:orderable)
    head :ok
  end
end
