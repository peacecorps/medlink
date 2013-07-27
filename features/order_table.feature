Feature: Visit "Order Table" Web Page
  As a visitor to the website
  I want to see everything that I expect on the order_table page
  so I can know that the site is working

  Scenario: Check stuff on "Order Table" page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials

    When I go to the order_table page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Log out" inside "a"

    Then I should see "Requester" inside "th"
    Then I should see "Request Date" inside "th"
    Then I should see "Location" inside "th"
    Then I should see "Requested Supplies" inside "th"
    Then I should see "Order" inside "th"
