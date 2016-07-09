require "rails_helper"

RSpec.describe SlackController do
  When { post :command, params: {
    token:        token,
    text:         text,
    user_id:      user_id,
    response_url: "/",
    user_name:    "Person"
  } }

  context "authorized" do
    Given(:token)   { Figaro.env.SLACK_COMMAND_TOKEN! }
    Given(:user_id) { Figaro.env.SLACK_ADMIN_IDS!.split(",").first }

    context "valid" do
      Given(:text) { "report orders" }

      Then { body.empty? }
    end

    context "invalid" do
      Given(:text) { "alsdkjfnalskjdfnaljsd" }

      Then { body =~ /unrecognized/i }
    end
  end

  context "unauthorized" do
    Given(:token)   { ":(" }
    Given(:user_id) { ":(" }
    Given(:text)    { "report orders" }

    Then { body =~ /unauthorized/i }
  end
end
