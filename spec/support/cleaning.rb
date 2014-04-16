RSpec.configure do |config|
  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end
  config.before :each, worker: true do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each)  { DatabaseCleaner.clean }

  # Clean out the seeds
  config.before(:all) { DatabaseCleaner.clean_with :truncation }
end
