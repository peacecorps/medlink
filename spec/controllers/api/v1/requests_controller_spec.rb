require "rails_helper"

RSpec.describe Api::V1::RequestsController do
  render_views

  Given(:volunteer)  { FactoryGirl.create :pcv }

  context "placing an order" do
    Given(:supply_ids) { volunteer.country.supplies.random(3).map &:id }

    When(:result)  { authorized(volunteer) { post :create, message: "Thanks!", supply_ids: supply_ids } }
    When(:request) { volunteer.requests.last }

    Then { result.status == 200                                }
    And  { request.supplies.pluck(:id).sort == supply_ids.sort }
    And  { json["request"]["created_at"].present?              }
  end

  context "with an invalid order" do
    When(:result) { authorized(volunteer) { post :create, supply_ids: [-1, "foo"] } }

    Then { result.status == 422                  }
    And  { Request.count == 0                    }
    And  { json["error"] == "Invalid"            }
    And  { json["failures"].first =~ /supplies/i }
  end

  context "when not authed" do
    Given(:country)    { Country.random }
    Given(:supply_ids) { country.supplies.random(3).map &:id }

    When(:result) { post :create, message: "Thanks!", supply_ids: supply_ids }

    Then { result.status == 401     }
    And  { json["error"] =~ /auth/i }
    And  { Request.count == 0       }
  end

  context "request history" do
    Given(:request) { FactoryGirl.create :request }

    When(:result) { authorized(request.user) { get :index } }

    Then { result.status == 200                                               }
    And  { json["requests"].first["created_at"] == request.created_at.as_json }
  end
end
