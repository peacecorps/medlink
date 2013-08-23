@wip
Feature: Visit "First Order" Web Page
  As a visitor to the website
  I want to see everything that I expect on the first_order page
  so I can know that the site is working

 Scenario: Check stuff on "First Order" page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    And I have one order

    Then I go to the first_order page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see link "Change Password"
    Then I should see link "Help"
    Then I should see link "Log out"

#TODO:    Then I should see "Back to all Orders" (inside span)
#TODO:    Then I should see "Order Form:" (inside span)
#TODO:    Then I should see "{name}"
#TODO:    Then I should see "PCV ID"
#TODO:    Then I should see "{city}"
#TODO:    Then I should see "{country}"
#TODO:    Then I should see "Order Action:" inside "h4"
#TODO:    Then I should see "Delivered to PCV" inside "label"
#TODO:    Then I should see "PCV Purchase" inside "label"
#TODO:    Then I should see "Delivered to Hub" inside "label"
#TODO:    Then I should see "Special Instructions" inside "label"
#TODO:    Then I should see field "Message" (placeholder)
#TODO:    Then I should see "Send"
