class CountrySupply < ApplicationRecord
  belongs_to :country
  belongs_to :supply

  validates_presence_of :country, :supply
  validates_uniqueness_of :supply, scope: :country
end
