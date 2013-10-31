Feature: Visit "Request History" Web Page
  As a visitor to the website
  I want to see everything that I expect on the request_history pages
  so I can know that the site is working

  Scenario Outline: Check stuff on User Deluxe "Request History" pages
    Given I exist as a user
    And I am a "<role>"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    Then I should see std gear area items
    Then I should see std icon area items
    Then I should see std tab area items

    #FIXME (#129): Then I should see dropdownmenu "Current Month"

    Then I should see column "First Name"
    Then I should see column "Last Name"
    Then I should see column "PCVID"
    Then I should see column "Supply"
    Then I should see column "Unit"
    Then I should see column "Quantity"
    Then I should see column "Location"
    Then I should see column "Requested"
    Then I should see column "Response"
    Then I should see column "Fulfilled"
    Examples:
    | role  |
    | pcmo  |
    | admin |

  Scenario: Check stuff on PCV "Request History" pages
    Given I exist as a user
    And I am a "pcv"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    Then I should see std gear area items
    Then I should see std icon area items

    Then I should see column "Supply"
    Then I should see column "Unit"
    Then I should see column "Quantity"
    Then I should see column "Requested"
    Then I should see column "Response"

