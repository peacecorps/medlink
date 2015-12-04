require "rails_helper"

RSpec.describe RequestPolicy do
  context "when a pcv" do
    Given(:pcv)  { FactoryGirl.build :pcv, id: rand(1..100) }
    Given(:pcmo) { FactoryGirl.build :pcmo, country: pcv.country, id: rand(101..200) }

    context "requesting for yourself" do
      When(:result) { pcv.personal_requests.new }

      Then { RequestPolicy.new(pcv, result).create? }
    end

    context "requesting for your PCVs" do
      When(:result) { pcmo.submitted_requests.new user: pcv }

      Then { RequestPolicy.new(pcmo, result).create? }
    end

    context "requesting for someone else" do
      When(:other)  { FactoryGirl.build :pcv, id: rand(201..300) }
      When(:result) { other.submitted_requests.new user: pcv }

      Then { !RequestPolicy.new(other, result).create? }
    end
  end
end
