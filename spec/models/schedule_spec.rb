require "spec_helper"

RSpec.describe Schedule do
  after(:all) { Timecop.return }

  context "with positive offsets" do
    Given(:schedule) { Schedule.new days: [3, 15, 30], hour: 9 }

    context "full month" do
      When { Timecop.travel Time.parse "2015-04-03" }
      Then { schedule.preview == "Apr 3rd, 15th, and 30th at 09:00" }
      And  { schedule.next_run == Time.parse("2015-04-03 09:00:00") }
    end

    context "short month" do
      When { Timecop.travel Time.parse "1990-02-01" }
      Then { schedule.preview == "Feb 3rd and 15th at 09:00" }
      And  { schedule.next_run == Time.parse("1990-02-03 09:00:00") }
    end

    context "at end of month" do
      When { Timecop.travel Time.parse "1950-05-30 10:00" }
      Then { schedule.preview == "May 3rd, 15th, and 30th at 09:00" }
      And  { schedule.next_run == Time.parse("1950-06-03 09:00:00") }
    end
  end

  context "with negative offsets" do
    Given(:schedule) { Schedule.new days: [-1, -30], hour: 23 }

    context "full month" do
      When { Timecop.travel Time.parse "2020-10-03" }
      Then { schedule.preview == "Oct 2nd and 31st at 23:00" }
    end

    context "short month" do
      When { Timecop.travel Time.parse "1990-02-15" }
      Then { schedule.preview == "Feb 28th at 23:00" }
    end
  end
end
