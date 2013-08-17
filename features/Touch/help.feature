Feature: Visit "Help" Web Page
  As a visitor to the website
  I want to see everything that I expect on the help page
  so I can know that the site is working

  Scenario: Check stuff on PCV "Help" page (not logged in)
    When I go to the help page
    And I am a "pcv"
    Then I should see std icon area items
#TODO/FIXME:    Then I should see std tab area items

    Then I should see "How to order personal medical supplies" inside "h2"
    Then I should see "How to place a request" inside "h2"
    Then I should see "Send an SMS" inside "h3"
    Then I should see "Fill Out a Web Form" inside "h3"
    Then I should see "I received a confirmation that my request was received - now what happens?" inside "h2"
    Then I should see "Pick Up" inside "h3"
    Then I should see "Delivery" inside "h3"
    Then I should see "Purchase" inside "h3"
    Then I should see "I received an error - what do I do?" inside "h2"
    Then I should see "Errors due to incorrect typing." inside "h3"
    Then I should see "Duplicate Requests for Same Medication" inside "h3"
    Then I should see "Network Connectivity" inside "h3"

  Scenario: Check stuff on PCMO "Help" page (not logged in)
    When I go to the help page
    And I am a "pcmo"
    Then I should see std icon area items
#TODO/FIXME:    Then I should see std tab area items

    Then I should see "How to order personal medical supplies" inside "h2"
    Then I should see "How to place a request" inside "h2"
    Then I should see "Send an SMS" inside "h3"
    Then I should see "Fill Out a Web Form" inside "h3"
    Then I should see "I received a confirmation that my request was received - now what happens?" inside "h2"
    Then I should see "Pick Up" inside "h3"
    Then I should see "Delivery" inside "h3"
    Then I should see "Purchase" inside "h3"
    Then I should see "I received an error - what do I do?" inside "h2"
    Then I should see "Errors due to incorrect typing." inside "h3"
    Then I should see "Duplicate Requests for Same Medication" inside "h3"
    Then I should see "Network Connectivity" inside "h3"

  Scenario: Check stuff on Admin "Help" page (not logged)
    When I go to the help page
    And I am a "admin"
    Then I should see std icon area items
#TODO/FIXME:    Then I should see std tab area items
#TODO/FIXME:    Then I should see tab "Admin Home"

    Then I should see "How to order personal medical supplies" inside "h2"
    Then I should see "How to place a request" inside "h2"
    Then I should see "Send an SMS" inside "h3"
    Then I should see "Fill Out a Web Form" inside "h3"
    Then I should see "I received a confirmation that my request was received - now what happens?" inside "h2"
    Then I should see "Pick Up" inside "h3"
    Then I should see "Delivery" inside "h3"
    Then I should see "Purchase" inside "h3"
    Then I should see "I received an error - what do I do?" inside "h2"
    Then I should see "Errors due to incorrect typing." inside "h3"
    Then I should see "Duplicate Requests for Same Medication" inside "h3"
    Then I should see "Network Connectivity" inside "h3"
