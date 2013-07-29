Feature: Visit "New Order" Web Page
  As a visitor to the website
  I want to see everything that I expect on the new_order page
  so I can know that the site is working

  Scenario: Check stuff on "New Order" page
    Given I exist as a user
    And I am not logged in
    And I sign in with valid credentials
    When I go to the new_order page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Log out" inside "a"

    Then I should see "Request Form" inside "h1"
    Then I should see "Select Supply" inside "option"
    Then I should see field "Dosage"
    Then I should see "Unit" inside "option"
    Then I should see field "Quantity"
    Then I should see field "Special requests for location or dosage"
    Then I should see the button "Submit"
#U#    Then I should see "Add a new supply request"
