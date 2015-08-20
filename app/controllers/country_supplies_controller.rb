class CountrySuppliesController < ApplicationController
  def index
    @country = current_user.country
    authorize @country, :manage_supplies?
    @supplies  = Supply.all
    @available = Set.new @country.country_supplies.pluck :supply_id
  end

  def create
    country = current_user.country
    authorize country, :manage_supplies?
    country.supplies.destroy_all
    Supply.find_each do |s|
      if params[s.name] == "1"
        country.supplies << s
      end
    end
    redirect_to :back
  end
end
