require 'rails_helper'

describe RequestForm do
  skip "Port these"
  #Given(:pcv)        { FactoryGirl.create :pcv }
  #Given(:pcmo)       { FactoryGirl.create :pcmo, country: pcv.country }
  #Given(:supplies)   { pcv.country.supplies.order("random()").first 3 }
  #Given(:supply_ids) { supplies.map &:id }

  #context "request for multiple supplies" do
  #  Given(:placer) { RequestPlacer.new placed_by: pcv, supply_ids: supply_ids, message: "Please!" }
  #  When(:result)  { placer.save && placer.request }

  #  Then { result.user == pcv                                 }
  #  And  { result.entered_by == pcv.id                        }
  #  And  { result.supplies.count == 3                         }
  #  And  { result.text == "Please!"                           }
  #  And  { result.persisted?                                  }
  #  And  { result.user.last_requested_at == result.created_at }
  #  And  { result.user.waiting_since     == result.created_at }
  #end

  #context "for a user" do
  #  Given(:placer) { RequestPlacer.new placed_by: pcmo, for_volunteer_id: pcv.id, supply_ids: supply_ids }

  #  When(:result) { placer.save && placer.request }

  #  Then { result.user == pcv           }
  #  And  { result.entered_by == pcmo.id }
  #end

  #context "without pcv" do
  #  Given(:placer) { RequestPlacer.new placed_by: pcmo, supply_ids: [] }

  #  When(:result) { placer.save }

  #  Then { result == false                          }
  #  And  { Request.count == 0                       }
  #  And  { placer.errors.include? :for_volunteer_id }
  #end

  #context "without supplies" do
  #  Given(:placer) { RequestPlacer.new placed_by: pcv, supply_ids: [] }

  #  When(:result) { placer.save }

  #  Then { result == false                  }
  #  And  { Request.count == 0               }
  #  And  { placer.errors.include? :supplies }
  #end

  #context "with non-offered supply" do
  #  Given(:supply) { FactoryGirl.create :supply }
  #  Given(:placer) { RequestPlacer.new placed_by: pcv, supply_ids: [supply.id] }

  #  When(:result) { placer.save }

  #  Then { result == false                  }
  #  And  { Request.count == 0               }
  #  And  { placer.errors.include? :supplies }
  #end

  #context "with duplicated orders" do
  #  Given!(:old) { RequestPlacer.new(placed_by: pcv, supply_ids: supply_ids.sample(2)).tap &:save }
  #  Given(:placer) { RequestPlacer.new(placed_by: pcv, supply_ids: supply_ids) }

  #  When(:result) { placer.save && placer.request }

  #  Then { result.user.last_requested_at == result.created_at  }
  #  And  { result.user.waiting_since == old.request.created_at }
  #  And  { result.created_at != old.request.created_at         }
  #  And  { old.request.orders.all? { |o| o.duplicated_at }     }
  #end
end
