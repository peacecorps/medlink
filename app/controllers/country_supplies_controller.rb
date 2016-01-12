class CountrySuppliesController < ApplicationController
  def index
    @country = CountrySuppliesPresenter.new current_user.country
    authorize @country, :manage_supplies?
  end

  def toggle
    country = current_user.country
    authorize country, :manage_supplies?
    country.toggle_supply params[:id]
    head :ok
  end
end
