if ENV["COVERAGE"]
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start 'rails' do
    add_group "Jobs", "app/jobs"

    add_filter ".bundle"
  end
end
