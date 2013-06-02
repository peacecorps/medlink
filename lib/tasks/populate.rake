require 'csv'

namespace :db do
  task :populate => :environment do
    CSV.read(Rails.root+"lib/tasks/supply.csv").each { |a| 
      Supply.new(:shortcode => a[1], :name => a[0]).save
    }

    CSV.read(Rails.root+"lib/tasks/country.csv", { :col_sep => ";" }).each { |a|
      Country.new(:code => a[1], :name => a[0]).save
    }
  end
end