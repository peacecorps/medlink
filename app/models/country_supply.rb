class CountrySupply < ActiveRecord::Base
  belongs_to :country
  belongs_to :supply
end
