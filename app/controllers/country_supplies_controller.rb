class CountrySuppliesController < ApplicationController
  def index
    @country = Country.find(active_country_id)
    @country_supplies = @country.supplies.map { |x| x.id }
    @supplies = Supply.all 
  end
  def create
    puts params
    @country = Country.find(active_country_id)
    @country.supplies.destroy_all
    @supplies = Supply.all
    @supplies.each do |s|
      if params[s.name] == "1"
        @country.supplies << s
      end
    end
    redirect_to :back
  end
end
