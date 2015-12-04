require "rails_helper"

RSpec.describe AnnouncementForm do
  Given(:admin)   { FactoryGirl.build :admin }
  Given(:pcmo)    { FactoryGirl.build :pcmo }
  Given(:country) { Country.random }

  context "scheduling as an admin" do
    Given(:form) { AnnouncementForm.new Announcement.new, announcer: admin }

    When(:result) { form.validate country_id: country.id,
                                  message: "Greetings and felicitations!", days: "3,-3", hour: "10" }

    Then { result == true                       }
    And  { form.sync.schedule.days = [3,-3]     }
    And  { form.days == "3, -3"                 }
    And  { form.hour == 10                      }
    And  { form.hour_choices.include? ["05", 5] }
    And  { form.preview.include? "3rd"          }
  end

  context "announcing as a pcmo" do
    Given(:form) { AnnouncementForm.new Announcement.new, announcer: pcmo }

    When(:result) { form.validate(country_id: country.id, message: "Greetings and felicitations!") && form.save }

    Then { result == true             }
    And  { form.model.schedule == nil }
  end

  context "disallows partial schedule" do
    Given(:form) { AnnouncementForm.new Announcement.new, announcer: admin }

    When(:result) { form.validate country_id: country.id,
                                  message: "Greetings and felicitations!", days: "3,-3" }

    Then { result == false                              }
    And  { form.errors[:hour].first.include? "required" }
  end

  context "scheduling as a pcmo" do
    Given(:form) { AnnouncementForm.new Announcement.new, announcer: pcmo }

    When(:result) { form.validate country_id: country.id,
                                  message: "Greetings and felicitations!", days: "1", hour: "12 "}

    Then { result == false }
  end
end
