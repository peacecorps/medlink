# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

puts "Creating intial records from seed data:"

CSV.read(Rails.root+"db/supply.csv").each do |name, shortcode|
  Supply.new(shortcode: shortcode, name: name).save
end
puts "... Loaded #{Supply.count} supplies"

File.read(Rails.root+"db/country.csv").each_line do |name|
  Country.new(name: name.strip).save
end
puts "... Loaded #{Country.count} countries"

puts "Please run `rake admin:create` if you would like to make an admin account"
    
    Country.find_each do |country|
      Supply.find_each do |supply|
       cs = CountrySupply.new
       cs.country_id = country.id
       cs.supply_id = supply.id
       cs.save
      end
    end
 
