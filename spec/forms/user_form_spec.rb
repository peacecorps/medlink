require "rails_helper"

RSpec.describe UserForm do
  Given(:admin) { FactoryGirl.build :admin }
  Given(:pcv)   { FactoryGirl.build :pcv }
  Given(:form)  { UserForm.new pcv, submitter: admin }

  context "changing name" do
    When(:result) { form.validate first_name: "New" }

    Then { result == true                                }
    And  { form.flash[:notice].include? "first_name=New" }
  end

  context "invalid phones" do
    When(:result) { form.validate phone_numbers: "1234" }

    Then { result == false                                           }
    And  { form.errors[:phone_numbers].first.include? "country code" }
  end

  context "valid phones" do
    When(:result) { form.validate phone_numbers: "+1234, +5678" }

    Then { result == true                                     }
    And  { form.flash[:notice].include? "phone_numbers=+1234" }
  end

  context "no changes" do
    When(:result) { form.validate first_name: pcv.first_name }

    Then { result == true                          }
    And  { form.flash[:alert] == "No changes made" }
  end

  context "country change" do
    Given(:newland) { FactoryGirl.create :country }

    When(:result) { form.validate country_id: newland.id }

    Then { result == true                                         }
    And  { form.flash[:notice].include? "country=#{newland.name}" }
  end

  context "invalid demotion" do
    Given(:form) { UserForm.new admin, submitter: admin }

    When(:result) { form.validate role: :pcv }

    Then { result == false            }
    And  { form.errors.include? :role }
  end
end
