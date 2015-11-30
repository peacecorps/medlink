require "rails_helper"

RSpec.describe PeriodicAnnouncementSender, :queue_jobs do
  Given(:at10) { Schedule.new days: [1,5,10], hour: 10 }
  Given(:mali) { FactoryGirl.build :announcement, country: Country.find_by(name: "Mali"), schedule: at10 }
  Given(:fiji) { FactoryGirl.build :announcement, country: Country.find_by(name: "Fiji"), schedule: at10 }
  Given(:sender) { PeriodicAnnouncementSender.new(announcements: [mali, fiji]) }

  context "start of the hour" do
    Given(:time) { ActiveSupport::TimeZone["Fiji"].parse "2015-05-05 10:03AM" }
    Given!(:now) { Timecop.travel time }

    When(:result) { sender.send_scheduled }

    Then { result.length == 1               }
    And  { result.first == fiji             }
    And  { queued(CountrySMSJob).count == 1 }
  end

  context "end of the hour" do
    Given(:time) { ActiveSupport::TimeZone["Fiji"].parse "2015-05-05 10:59AM" }
    Given!(:now) { Timecop.travel time }

    When(:result) { sender.send_scheduled }

    Then { result.length == 1               }
    And  { result.first == fiji             }
    And  { queued(CountrySMSJob).count == 1 }
  end

  context "on an off hour" do
    Given(:time) { ActiveSupport::TimeZone["Hawaii"].parse "2015-05-05 10:03AM" }
    Given!(:now) { Timecop.travel time }

    When(:result) { sender.send_scheduled }

    Then { result.length == 0               }
    And  { queued(CountrySMSJob).count == 0 }
  end

  context "re-running in the hour" do
    Given(:time) { ActiveSupport::TimeZone["Fiji"].parse "2015-05-05 10:03AM" }
    Given!(:now) { Timecop.travel time }

    When(:result) { 3.times { sender.send_scheduled; Timecop.travel(5.minutes.from_now) } }

    Then { queued(CountrySMSJob).count == 1 }
  end

  after(:all) { Timecop.return }
end
