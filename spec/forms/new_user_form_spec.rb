require "rails_helper"

RSpec.describe NewUserForm do
  Given(:admin) { FactoryGirl.build :admin }
  Given(:pcv)   { FactoryGirl.attributes_for :pcv }
  Given(:attrs) { pcv.merge country_id: pcv[:country].id }

  context "with a valid form" do
    Given(:form) { NewUserForm.new User.new, submitter: admin }

    When(:result) { form.validate attrs }

    Then { result == true }
  end

  context "with an invalid email" do
    Given(:saved) { FactoryGirl.create :pcv }
    Given(:form)  { NewUserForm.new User.new, submitter: admin }

    When(:result) { form.validate attrs.merge(email: saved.email) }

    Then { result == false                             }
    And  { form.errors[:email] == ["is already taken"] }
  end
end
