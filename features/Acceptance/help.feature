Feature: Visit "Help" Web Page
  As a visitor to the website
  I want to see everything that I expect on the help page
  so I can know that the site is working

  Scenario Outline: Check stuff on User "Help" page
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I go to the help page
    And I am a "<role>"
    Then I should see std icon area items
    Then I should see <tabtype> tab area items

    Then I should see header with text "How to order personal medical supplies"
    Then I should see header with text "How to place a request"
    Then I should see header with text "Send an SMS"
    Then I should see header with text "Fill Out a Web Form"
    Then I should see header with text "I received a confirmation that my request was received, now what happens?"
    Then I should see header with text "Pick Up"
    Then I should see header with text "Delivery"
    Then I should see header with text "Purchase"
    Then I should see header with text "I received an error what do I do?"
    Then I should see header with text "Errors due to incorrect typing:"
    Then I should see header with text "Duplicate Requests for Same Medication"
    Then I should see header with text "Network Connectivity"
    Examples:
    | role  | tabtype |
    | pcv   | none    |
    | pcmo  | std     |
    | admin | admin   |
