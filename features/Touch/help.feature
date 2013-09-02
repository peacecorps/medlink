Feature: Visit "Help" Web Page
  As a visitor to the website
  I want to see everything that I expect on the help page
  so I can know that the site is working

  Scenario: Check stuff on PCV "Help" page (not logged in)
    When I go to the help page
    And I am a "pcv"
    Then I should see std icon area items
#TODO/FIXME:    Then I should see std tab area items

    Then I should see header with text "How to order personal medical supplies"
    Then I should see header with text "How to place a request"
    Then I should see header with text "Send an SMS"
    Then I should see header with text "Fill Out a Web Form"
    Then I should see header with text "I received a confirmation that my request was received - now what happens?"
    Then I should see header with text "Pick Up"
    Then I should see header with text "Delivery"
    Then I should see header with text "Purchase"
    Then I should see header with text "I received an error - what do I do?"
    Then I should see header with text "Errors due to incorrect typing:"
    Then I should see header with text "Duplicate Requests for Same Medication"
    Then I should see header with text "Network Connectivity"

  Scenario: Check stuff on PCMO "Help" page (not logged in)
    When I go to the help page
    And I am a "pcmo"
    Then I should see std icon area items
#TODO/FIXME:    Then I should see std tab area items

    Then I should see header with text "How to order personal medical supplies"
    Then I should see header with text "How to place a request"
    Then I should see header with text "Send an SMS"
    Then I should see header with text "Fill Out a Web Form"
    Then I should see header with text "I received a confirmation that my request was received - now what happens?"
    Then I should see header with text "Pick Up"
    Then I should see header with text "Delivery"
    Then I should see header with text "Purchase"
    Then I should see header with text "I received an error - what do I do?"
    Then I should see header with text "Errors due to incorrect typing:"
    Then I should see header with text "Duplicate Requests for Same Medication"
    Then I should see header with text "Network Connectivity"

  Scenario: Check stuff on Admin "Help" page (not logged)
    When I go to the help page
    And I am a "admin"
    Then I should see std icon area items
#TODO/FIXME:    Then I should see admin tab area items

    Then I should see header with text "How to order personal medical supplies"
    Then I should see header with text "How to place a request"
    Then I should see header with text "Send an SMS"
    Then I should see header with text "Fill Out a Web Form"
    Then I should see header with text "I received a confirmation that my request was received - now what happens?"
    Then I should see header with text "Pick Up"
    Then I should see header with text "Delivery"
    Then I should see header with text "Purchase"
    Then I should see header with text "I received an error - what do I do?"
    Then I should see header with text "Errors due to incorrect typing:"
    Then I should see header with text "Duplicate Requests for Same Medication"
    Then I should see header with text "Network Connectivity"
