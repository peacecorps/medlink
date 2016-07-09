require "rails_helper"

RSpec.describe Api::V1::RequestsController do
  context "placing an order" do
    Given(:supply_ids) { pcv.country.supplies.random(3).map(&:id) }

    As   { pcv }
    When { post :create, params: { message: "Thanks!", supply_ids: supply_ids } }

    When(:request) { volunteer.requests.last }

    Then { status == 200                                                 }
    And  { pcv.requests.last.supplies.pluck(:id).sort == supply_ids.sort }
    And  { json["request"]["created_at"].present?                        }
  end

  context "with an invalid order" do
    As   { pcv }
    When { post :create, params: { supply_ids: [-1, "foo"] } }

    Then { status == 422                         }
    And  { error == "Invalid"                    }
    And  { Request.count == 0                    }
    And  { json["failures"].first =~ /supplies/i }
  end

  context "when not authed" do
    Given(:supply_ids) { country.supplies.random(3).map(&:id) }

    When { post :create, params: { message: "Thanks!", supply_ids: supply_ids } }

    Then { status == 401      }
    And  { error =~ /auth/i   }
    And  { Request.count == 0 }
  end

  context "request history" do
    Given(:request) { create :request }

    As   { request.user }
    When { get :index }

    Then { status == 200                                                      }
    And  { json["requests"].first["created_at"] == request.created_at.as_json }
  end
end
