RSpec.configure do |config|
  config.before :each do
    ActionMailer::Base.deliveries.clear
  end

  config.include(Module.new do
    def sent_mail
      ActionMailer::Base.deliveries
    end
  end)
end
