module ApiHelpers
  def authorized user, &block
    resp = block.call
    if resp.status == 401
      ApiAuth.sign! @request, user.id, user.secret_key
      block.call
    else
      resp
    end
  end

  def json
    @_json ||= JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :controller
end
