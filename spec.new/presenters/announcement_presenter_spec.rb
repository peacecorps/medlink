require "rails_helper"

describe AnnouncementPresenter do
  Given(:phone)        { FactoryGirl.create :phone }
  Given(:country)      { phone.user.country }
  Given(:schedule)     { Schedule.new days: [1,2,3,20], hour: 23 }
  Given(:announcement) { FactoryGirl.build :announcement, country: country, schedule: schedule }

  When(:result) { AnnouncementPresenter.new announcement }

  Then { result.days == "1, 2, 3, 20" }
  And  { result.hour == 23            }
  And  { result.reach == 1            }
end
