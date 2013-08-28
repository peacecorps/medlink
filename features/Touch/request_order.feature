Feature: Visit "Request Order" Web Page
  As a visitor to the website
  I want to see everything that I expect on the request_order page
  so I can know that the site is working

#----------------------------------------------------------------------
  Scenario: Check stuff on PCV "Request Order" page
    Given I exist as a user
    And I am a "pcv"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the new_order page
    Then I should see std icon area items
    Then I should see std gear area items

    Then I should see header with text "Request Form"
    Then I should see dropdownmenu "Select Supply"
    Then I should see field "Location"
    Then I should see field "Quantity"
    Then I should see field "Units"
    Then I should see field "Special instructions area"
    Then I should see the button "Submit"

#----------------------------------------------------------------------
  Scenario: Check stuff on PCMO "Request Order" page
    Given I exist as a user
    And I am a "pcmo"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the new_order page
    Then I should see std icon area items
    Then I should see std gear area items

    Then I should see header with text "Request Form"
#TODO/FIXME: Then I should see field "Select Volunteer to request for"
    Then I should see dropdownmenu "Select Supply"
    Then I should see field "Location"
    Then I should see field "Quantity"
    Then I should see field "Units"
    Then I should see field "Special instructions area"
    Then I should see the button "Submit"

#----------------------------------------------------------------------
  Scenario: Check stuff on ADMIN "Request Order" page
    Given I exist as a user
    And I am a "admin"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the new_order page
    Then I should see std icon area items
    Then I should see std gear area items
    Then I should see admin tab area items

    Then I should see header with text "Request Form"
#TODO/FIXME: Then I should see field "Select Volunteer to request for"
    Then I should see dropdownmenu "Select Supply"
    Then I should see field "Location"
    Then I should see field "Quantity"
    Then I should see field "Units"
    Then I should see field "Special instructions area"
    Then I should see the button "Submit"

