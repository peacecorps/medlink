require "rails_helper"

RSpec.describe Announcement do
  context "serialization" do
    Given(:schedule)   { Schedule.new days: [5,15], hour: 9 }
    Given(:serialized) { FactoryGirl.create :announcement, schedule: schedule }

    When(:result) { Announcement.find serialized.id }

    Then { result.schedule == serialized.schedule }
  end

  context "scheduling" do
    Given!(:a1) { FactoryGirl.create :announcement, schedule: Schedule.new(days: [5, 20], hour: 5) }
    Given!(:a2) { FactoryGirl.create :announcement, schedule: Schedule.new(days: [9, -5], hour: 9) }
    Given!(:a3) { FactoryGirl.create :announcement, schedule: Schedule.new(days: [11], hour: 14) }

    When { Timecop.travel Time.parse "1986-04-08 10:00" }

    Then { Announcement.scheduled.count == 3 }
    And  { Announcement.next(2) == [a2, a3]  }
  end
end
