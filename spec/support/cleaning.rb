RSpec.configure do |config|
  config.around(:each) do |x|
    if x.metadata[:js]
      x.run
      clean!
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
      x.run
      DatabaseCleaner.clean
    end
  end
end
