Feature: Visit "Request Order" Web Page
  As a visitor to the website
  I want to see everything that I expect on the request_order page
  so I can know that the site is working

TOUCHSTART
  * PCV - Request Form (was: New Order ("#/orders/new"))
*TODO: Change "Request Form" title to "Place a Request"
*TODO: No 3 Tabs?
    * "Request" title, Gear
    * First Name
    * Last Name
    * PCV ID
    * std: (CHANGED) "Select Supply" dropdown (list)
    * std: (NEW) Location
    * (EXTRA) std: Dosage
*TODO: MUST ADD DOSAGE BACK.**
    * std: Quantity (drop "Dosage" and "Unit")
    * std: (NEW) "Special instructions area" (was: "Special
      requests for location or dosage")
    * (DROP) "Add a new supply request" button (duplicates the entry form)
    * std: Submit button

  * PCMO - Place a Request
    * Icon, 3 tabs(Request Manager, Place a Request, Reports), Gear
    * (NEW) Current Month
    * "Place a Request" title
    * (NEW) "Select Volunteer to request for" menu
    * std: "Select Supply" dropdown (list)
    * std: (NEW) Location
    * std: Dosage
    * std: Quantity
    * std: (NEW) "Special instructions area"
    * std: Submit button

  * Admin - Place a Request
    * Icon, 4 tabs(Admin Home, Request Manager, Place a Request,
      Reports), Gear
    * "Place a Request" title
    * (NEW) "Select Volunteer to request for" menu
    * std: "Select Supply" dropdown (list)
    * std: (NEW) Location
    * std: Dosage
    * std: Quantity
    * std: (NEW) "Special instructions area"
    * std: Submit button
TOUCHEND

#----------------------------------------------------------------------
  Scenario: Check stuff on PCV "Request Order" page
    Given I exist as a user
    And I am a "pcv"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the new_order page
    Then I should see std icon area items
    Then I should see std gear area items

    Then I should see "Request Form" inside "h1"
#TODO:    * First Name
#TODO:    * Last Name
#TODO:    * PCV ID
    Then I should see "Select Supply" inside "option"
#TODO:    Then I should see field "Location"
    Then I should see field "Dosage"
    Then I should see "Unit" inside "option"
    Then I should see field "Quantity"
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

#TODO: Current Month
#TODO:    Then I should see "Place a Request" inside "h1"
#TODO: "Select Volunteer to request for" menu
    Then I should see "Select Supply" inside "option"
#TODO:    Then I should see field "Location"
    Then I should see field "Dosage"
    Then I should see "Unit" inside "option"
    Then I should see field "Quantity"
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
#TODO: 4 tabs

#TODO:    Then I should see "Place a Request" inside "h1"
#TODO: "Select Volunteer to request for" menu
    Then I should see "Select Supply" inside "option"
#TODO:    Then I should see field "Location"
    Then I should see field "Dosage"
    Then I should see "Unit" inside "option"
    Then I should see field "Quantity"
    Then I should see field "Special instructions area"
    Then I should see the button "Submit"

