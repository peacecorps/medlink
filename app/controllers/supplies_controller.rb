class SuppliesController < ApplicationController
  before_action do
    authorize :supply, :manage_master_supply_list?
  end

  def index
    @supplies = SupplyPresenter.decorate_collection Supply.all.order name: :asc
  end

  def new
    @supply = Supply.new
  end

  def create
    @supply = Supply.new(params.require(:supply).permit :shortcode, :name)
    if @supply.save
      # TODO: should this be on or off for countries by default?
      redirect_to supplies_path
    else
      render :new
    end
  end

  def toggle_orderable
    supply = Supply.find params[:id]
    supply.toggle!(:orderable)
    redirect_to :back
  end
end
