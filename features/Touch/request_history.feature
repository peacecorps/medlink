Feature: Visit "Request History" Web Page
  As a visitor to the website
  I want to see everything that I expect on the request_history pages
  so I can know that the site is working

  Scenario: Check stuff on PCV "Request History" pages
    Given I exist as a user
    And I am a "pcmo"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    Then I should see std gear area items
    Then I should see std icon area items
    Then I should see std tab area items

    Then I should see column "Requester"
    Then I should see column "Requested Supplies"
    Then I should see column "Unit"
    Then I should see column "Quantity"
    Then I should see column "Location"
    Then I should see column "Request Date"

  Scenario: Check stuff on PCMO "Request History" pages
    Given I exist as a user
    And I am a "pcmo"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    Then I should see std gear area items
    Then I should see std icon area items
    Then I should see std tab area items

    Then I should see column "Requester"
    Then I should see column "Requested Supplies"
    Then I should see column "Unit"
    Then I should see column "Quantity"
    Then I should see column "Location"
    Then I should see column "Request Date"

  Scenario: Check stuff on Admin "Request History" pages
    Given I exist as a user
    And I am a "admin"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    Then I should see std gear area items
    Then I should see std icon area items
    Then I should see admin tab area items

    Then I should see column "Requester"
    Then I should see column "Requested Supplies"
    Then I should see column "Unit"
    Then I should see column "Quantity"
    Then I should see column "Location"
    Then I should see column "Request Date"
