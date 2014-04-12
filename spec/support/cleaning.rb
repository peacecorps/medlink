RSpec.configure do |config|
  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end
  config.before :each, worker: true do
    DatabaseCleaner.strategy = :truncation
  end
  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end
end
