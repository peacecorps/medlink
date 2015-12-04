namespace :db do
  desc "Truncate all tables (RAILS_ENV=test only)"
  task :truncate => :environment do
    raise unless Rails.env.test?
    DatabaseCleaner.clean_with :truncation
  end
end
