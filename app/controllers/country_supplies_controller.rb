class CountrySuppliesController < ApplicationController
  def index
    if active_country?
      @country = Country.find(active_country_id)
      @country_supplies = @country.supplies.map { |x| x.id }
    end
    @supplies = Supply.all
  end
  def create
    authorize! :manage , CountrySupply
    @country = Country.find(active_country_id)
    @country.supplies.destroy_all
    @supplies = Supply.all
    @supplies.each do |s|
      if params[s.name] == "1"; @country.supplies << s end
    end
    redirect_to :back
  end
end
