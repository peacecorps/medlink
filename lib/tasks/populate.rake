require 'csv'

namespace :db do
  task :populate => :environment do
    CSV.read(Rails.root+"lib/tasks/supply.csv").each { |a|
      Supply.new(:shortcode => a[1], :name => a[0]).save
    }

    CSV.read(Rails.root+"lib/tasks/country.csv", { :col_sep => ";" }).each { |a|
      Country.new(:code => a[1], :name => a[0]).save
    }

    CSV.read(Rails.root+"lib/tasks/user.csv").each do |a|
      role = a[1] == 'Dabbs' ? 'admin' : nil
      User.new(:first_name => a[0], :last_name => a[1], :country_id => 1, :email => a[2], :pcv_id => a[3], :role => role).save
    end
  end
end