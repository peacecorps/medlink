require "rails_helper"

RSpec.describe Api::V1::SuppliesController do
  Given(:country) { pcv.country }
  Given(:supply)  { country.supplies.random }

  context "user list" do
    context "when unauthed" do
      When { get :index }

      Then { status == 401    }
      And  { error =~ /auth/i }
    end

    context "when authed" do
      Given!(:gone) { country.supplies.delete supply }

      As   { pcv }
      When { get :index }

      Then { status == 200 }
      And  { json["supplies"].count == country.supplies.count }
      And  { json["supplies"].first.keys == %w(id name shortcode) }
    end
  end

  context "master list" do
    context "when unauthed" do
      When { get :master_list }

      Then { status == 401    }
      And  { error =~ /auth/i }
    end

    context "when authed" do
      Given!(:gone) { country.supplies.delete supply }

      As   { pcv }
      When { get :master_list }

      Then { status == 200 }
      And  { json["supplies"].count > country.supplies.count }
      And  { json["supplies"].first.keys == %w(id name shortcode) }
    end
  end
end
