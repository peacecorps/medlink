RSpec::Matchers.define :have_validation_error do |label, message|
  # TODO: refactor existing specs to use this matcher
  match do |page|
    field = page.find ".has-error", text: label
    field.has_content? message
  end
end
