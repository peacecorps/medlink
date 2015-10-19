class AttachTimezonesToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :time_zone, :string

    Country.reset_column_information

    require 'csv'
    CSV.foreach Rails.root.join("db", "timezones.csv") do |name, zone_name, offset|
      next if name == "country"
      c = Country.find_by_name! name
      c.update! time_zone: zone_name
    end

    raise if Country.where(time_zone: nil).exists?
  end
end
