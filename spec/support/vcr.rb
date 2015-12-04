VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
end

RSpec.configure do |config|
  config.around :each, :vcr do |x|
    name = x.full_description.gsub /\W+/, '-'
    VCR.use_cassette name, re_record_interval: 1.week do
      x.run
    end
  end
end
