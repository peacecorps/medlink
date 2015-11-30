require "rails_helper"

RSpec.describe Api::V1::SuppliesController do
  render_views

  context "when unauthed" do
    When(:result) { get :index }

    Then { result.status == 401 }
    And  { json["error"] =~ /auth/ }
  end

  context "when authed" do
    Given(:user)    { FactoryGirl.create :user }
    Given(:country) { user.country }
    Given(:supply)  { country.supplies.random }
    Given!(:gone)   { country.supplies.delete supply }

    When(:result) { authorized(user) { get :index } }

    Then { result.status == 200 }
    And  { json["supplies"].count == country.supplies.count }
    And  { json["supplies"].first.keys == %w(id name shortcode) }
  end
end
