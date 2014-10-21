require 'csv'

class EnsureSupplies < ActiveRecord::Migration
  def up
    CSV.read(Rails.root.join "db", "supply.csv").each do |name, shortcode|
      Supply.where(shortcode: shortcode, name: name).first_or_create!
    end
  end

  def down
    raise "Irreversable migration"
  end
end
