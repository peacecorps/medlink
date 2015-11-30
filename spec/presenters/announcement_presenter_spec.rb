require "rails_helper"

RSpec.describe AnnouncementPresenter do
  before(:all) { Timecop.return }

  context "with a schedule" do
    Given(:schedule)     { Schedule.new days: [1,5], hour: 10 }
    Given(:announcement) { FactoryGirl.build :announcement, id: 1, schedule: schedule, last_sent_at: Time.new(2015, 11, 01) }
    Given!(:pcv) { FactoryGirl.create :pcv, country: announcement.country }

    When(:result) { AnnouncementPresenter.new announcement }

    Then { result.country == announcement.country.name }
    And  { result.reach == 1                           }
    And  { result.preview.include? "1st"               }
    And  { result.last_sent == "November 01"           }
    And  { !result.send_button.include? "disabled"     }
  end

  context "sent recently" do
    Given(:announcement) { FactoryGirl.build :announcement, id: 1, last_sent_at: 10.minutes.ago }

    When(:result) { AnnouncementPresenter.new announcement }

    Then { result.send_button.include? "disabled" }
  end

  context "never sent" do
    Given(:announcement) { FactoryGirl.build :announcement, id: 1, last_sent_at: nil }

    When(:result) { AnnouncementPresenter.new announcement }

    Then { !result.send_button.include? "disabled" }
    And  { result.last_sent == "Never"             }
  end
end
