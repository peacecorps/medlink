class AddDefaultDataForCountrySupplies < ActiveRecord::Migration
  def change 
    Country.find_each do |country|
      Supply.find_each do |supply|
       cs = CountrySupply.new
       cs.country_id = country.id
       cs.supply_id = supply.id
       cs.save
      end
    end
  end
end
