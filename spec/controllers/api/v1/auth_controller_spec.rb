require "rails_helper"

RSpec.describe Api::V1::AuthController do
  context "testing unauthed" do
    When { get :test }

    Then { status == 401    }
    And  { error =~ /auth/i }
  end

  context "testing authed" do
    As   { pcv }
    When { get :test }

    Then { status == 200              }
    And  { json["email"] == pcv.email }
  end

  context "logging in" do
    When { post :login, params: { email: pcv.email, password: "password" } }

    Then { status == 200                               }
    And  { json["secret_key"] == pcv.reload.secret_key }
  end

  context "failing to log in" do
    When { post :login, params: { email: pcv.email, password: "hunter2" } }

    Then { status == 401                                   }
    And  { json["error"] == "Invalid username or password" }
  end

  context "logging in with phone number" do
    Given(:phone) { create :phone }

    When { post :phone_login, params: { number: phone.number, token: Figaro.env.telegram_bot_token! } }

    Then { status == 200 }
    And  { json["id"]         == phone.user_id         }
    And  { json["secret_key"] == phone.user.secret_key }
  end

  context "logging in with phone number without a token" do
    Given(:phone) { create :phone }

    When { post :phone_login, params: { number: phone.number } }

    Then { status == 401 }
  end
end
