require "rails_helper"

RSpec.describe Api::V1::AuthController do
  render_views

  Given(:pcv) { FactoryGirl.create :pcv }

  context "testing unauthed" do
    When(:result) { get :test }

    Then { result.status == 401    }
    And  { json["error"] =~ /auth/ }
  end

  context "testing authed" do
    When(:result) { authorized(pcv) { get :test } }

    Then { result.status == 200       }
    And  { json["email"] == pcv.email }
  end

  context "logging in" do
    When(:result) { post :login, email: pcv.email, password: "password" }

    Then { result.status == 200                        }
    And  { json["secret_key"] == pcv.reload.secret_key }
  end

  context "failing to log in" do
    When(:result) { post :login, email: pcv.email, password: "hunter2" }

    Then { result.status == 401                            }
    And  { json["error"] == "Invalid username or password" }
  end
end
