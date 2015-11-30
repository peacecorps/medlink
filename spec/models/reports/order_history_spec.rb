require "rails_helper"

RSpec.describe Report::OrderHistory do
  Given!(:r1) { FactoryGirl.create :response }
  Given!(:r2) { FactoryGirl.create :response }

  When(:result) { CSV.parse Report::OrderHistory.new(Order.all).to_csv, headers: true }

  Then { result.count == 2                         }
  And  { result.first.to_hash.keys.include? "Item" }
end
