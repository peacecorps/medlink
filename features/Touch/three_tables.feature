@touch
Feature: Visit "Three Tables" Web Page
  As a visitor to the website
  I want to see everything that I expect on the three_tables pages
  so I can know that the site is working

#----------------------------------------------------------------------
  Scenario: Check stuff on "Three Tables: PCMO - Request Manager" pages
    Given I exist as a user
    And I am a "pcmo"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the request_manager page
    Then I should see std icon area items
    Then I should see std gear area items
    Then I should see std tab area items

    Then I should see header with text "Request Manager"
    Then I should see header with text "Past Due Requests"
    Then I should see header with text "Pending Requests"
    Then I should see header with text "Response Tracker"

    Then I should see column "Response"
    Then I should see column "Fulfilled"
    Then I should see column "Received"

    Then I should see 3 columns of "PCVID"
    Then I should see 3 columns of "First Name"
    Then I should see 3 columns of "Last Name"
    Then I should see 3 columns of "Supply"
    Then I should see 3 columns of "Unit"
    Then I should see 3 columns of "Quantity"
    Then I should see 3 columns of "Location"
    Then I should see 3 columns of "Request"

#----------------------------------------------------------------------
  Scenario: Check stuff on "Three Tables: Admin - Request Manager" pages
#TODO: Missing country dropdown menu.
    Given I exist as a user
    And I am a "admin"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the request_manager page
    Then I should see std icon area items
    Then I should see std gear area items
    Then I should see std tab area items
    Then I should see admin tab area items

    Then I should see header with text "Request Manager"
    Then I should see header with text "Past Due Requests"
    Then I should see header with text "Pending Requests"
    Then I should see header with text "Response Tracker"

    Then I should see column "Response"
    Then I should see column "Fulfilled"
    Then I should see column "Received"

    Then I should see 3 columns of "PCVID"
    Then I should see 3 columns of "First Name"
    Then I should see 3 columns of "Last Name"
    Then I should see 3 columns of "Supply"
    Then I should see 3 columns of "Unit"
    Then I should see 3 columns of "Quantity"
    Then I should see 3 columns of "Location"
    Then I should see 3 columns of "Request"
