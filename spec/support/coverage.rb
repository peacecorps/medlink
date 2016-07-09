# N.B. There are some subtleties in the interaction between SimpleCov and
#   Spring. See `config/spring.rb` for more info.
require "simplecov"
require "coveralls"
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start "rails" do
  add_group "Forms",      "app/forms"
  add_group "Jobs",       "app/jobs"
  add_group "Policies",   "app/policies"
  add_group "Presenters", "app/presenters"
  add_group "Services",   "app/services"

  add_filter "/lib/slackbot"
end
