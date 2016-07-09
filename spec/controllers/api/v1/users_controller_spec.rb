require "rails_helper"

RSpec.describe Api::V1::UsersController do
  Given(:pcmo) { create :pcmo, country: pcv.country }

  context "pcmo can view a roster" do
    As   { pcmo }
    When { get :index }

    Then { status == 200             }
    And  { json["users"].length == 2 }
  end

  context "admin can view a country roster" do
    As   { admin }
    When { get :index, params: { country_id: pcmo.country_id } }

    Then { status == 200             }
    And  { json["users"].length == 2 }
  end

  context "pcv can view a roster" do
    As   { pcv }
    When { get :index }

    Then { status == 403 }
  end

  context "pcvs can't edit their accounts" do
    As   { pcv }
    When { patch :update, params: { id: pcv.id } }

    Then { status == 403 }
  end

  context "pcmos can edit their pcvs accounts" do
    As   { pcmo }
    When { patch :update, params: { id: pcv.id, user: { phones: %w(+111 +222) } } }

    Then { status == 200 }
    And  { pcv.reload.phones.first.number == "+111" }
  end

  context "edits check validations" do
    As   { pcmo }
    When { patch :update, params: { id: pcv.id, user: { email: pcmo.email, phones: %w(111) } } }

    Then { status == 422 }
    And  { json["errors"].first =~ /country code/ }
    And  { json["errors"].last  =~ /^Email/       }
  end
end
