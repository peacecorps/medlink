require "spec_helper"

describe Announcement do
  context "serialization" do
    Given(:schedule)   { Schedule.new days: [5,15], hour: 9 }
    Given(:serialized) { FactoryGirl.create :announcement, schedule: schedule }

    When(:result) { Announcement.find serialized.id }

    Then { result.schedule == serialized.schedule }
  end
end
