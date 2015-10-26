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
  Supply.new(shortcode: shortcode, name: name).save!
end
puts "... Loaded #{Supply.count} supplies"


tzs = {}
CSV.read(Rails.root+"db/timezones.csv").each do |country, zone, offset|
  tzs[country] = zone
end

File.read(Rails.root+"db/country.csv").each_line do |name|
  name.strip!
  tz = tzs.fetch name
  Country.new(name: name, time_zone: tz).save!
end
puts "... Loaded #{Country.count} countries"

puts "Please run `rake admin:create` if you would like to make an admin account"

supplies = Supply.all
Country.all.each do |country|
  country.supplies << supplies
end
