module ApiHelpers
  extend RSpec::SharedContext

  let(:pcv)     { create :pcv    }
  let(:pcmo)    { create :pcmo   }
  let(:admin)   { create :admin  }
  let(:country) { Country.random }

  def log_in user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  def json
    @_json ||= JSON.parse(@response.body)
  end

  def status
    @response.status
  end

  def error
    json["error"]
  end

  def self.included other
    super
    other.render_views
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ApiHelpers, type: :controller
end
