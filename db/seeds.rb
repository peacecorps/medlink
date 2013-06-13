# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

puts "Creating intial records from seed data:"

CSV.read(Rails.root+"db/supply.csv").each do |a|
  Supply.new(:shortcode => a[1], :name => a[0]).save
end
puts "... Loaded #{Supply.count} supplies"

CSV.read(Rails.root+"db/country.csv", { :col_sep => ";" }).each do |a|
  Country.new(:code => a[1], :name => a[0]).save
end
puts "... Loaded #{Country.count} supplies"

puts "Please run `rake admin:create` if you would like to make an admin account"
