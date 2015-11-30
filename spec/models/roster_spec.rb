require "rails_helper"

RSpec.describe Roster do
  Given(:country) { Country.random }
  Given(:body) { %{
    email,phone,phone2,first_name,last_name,pcv_id,role,location,time_zone
    a@example.com,+1555,,A,User,1,pcv,Place,Fiji
    b@example.com,+1556,+1557,B,User,2,pcv,Place,Fiji
  } }
  Given(:initial) { Roster.from_csv body, country: country }

  context "loading an initial roster" do
    When(:result) { initial.save }

    Then { result == true                                            }
    And  { country.users.pcv.count == 2                              }
    And  { Phone.count == 3                                          }
    And  { mail.map(&:to).flatten == country.users.pcv.pluck(:email) }
  end

  context "updating an existing roster" do
    Given(:updated) { Roster.from_csv %{
      email,phone,phone2,first_name,last_name,pcv_id,role,location,time_zone
      a@example.com,+1555,,A,User,1,pcv,New Place,Fiji
      c@example.com,+1558,,C,User,3,pcv,Place,Eastern Time (US & Canada)
    }, country: country }

    When          { initial.save }
    When          { mail.clear   }
    When(:result) { updated.save }

    Then { result == true                                                        }
    And  { country.users.pcv.count == 2                                          }
    And  { country.users.find_by(email: "a@example.com").location == "New Place" }
    And  { !country.users.unscoped.find_by(email: "b@example.com").active?       }
    And  { country.users.find_by(email: "c@example.com").first_name == "C"       }
    And  { mail.count == 1                                                       }
    And  { mail.last.to == ["c@example.com"]                                     }
  end

  context "loading from upload" do
    Given(:upload) { FactoryGirl.build :roster_upload, body: body }

    When(:result) { upload.roster }

    Then { result.active_emails == %w(a@example.com b@example.com) }
  end
end
