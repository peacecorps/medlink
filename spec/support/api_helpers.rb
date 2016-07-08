module ApiHelpers
  def authorized user, &block
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    block.call
  end

  def json
    @_json ||= JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ApiHelpers, type: :controller
end
