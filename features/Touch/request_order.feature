Feature: Visit "New Order" Web Page
  As a visitor to the website
  I want to see everything that I expect on the new_order page
  so I can know that the site is working

TOUCHSTART
  * PCV - Request Form (was: New Order ("#/orders/new"))
    * "Request" title, Gear
    * First Name
    * Last Name
    * PCV ID
    * (CHANGED) "Select Supply" dropdown (list)
    * (NEW) Location
    * Quantity (drop "Dosage" and "Unit")
**AL> MUST ADD DOSAGE BACK.**
    * (NEW) "Special instructions area"
    * (DROP) "Special requests for location or dosage"
    * (DROP) "Add a new supply request" button (duplicates the
      entry form)
    * Submit button

  * PCMO - Place a Request
    * Icon, 3 tabs(Request Manager, Place a Request, Reports),
      Gear, Current Month"
    * "Place a Request" title, "Select Volunteer to request for" menu
    * "Select Supply" dropdown (list)
    * (NEW) Location
    * Dosage
    * Quantity
    * (NEW) "Special instructions area"
    * Submit button

  * Admin - Place a Request
    * Icon, 4 tabs(Admin Home, Request Manager, Place a Request,
      Reports), Gear
    * "Place a Request" title, "Select Volunteer to request for" menu
    * "Select Supply" dropdown (list)
    * (NEW) Location
    * Dosage
    * Quantity
    * (NEW) "Special instructions area"
    * Submit button
TOUCHEND

  Scenario: Check stuff on "New Order" page
    Given I exist as a user
    And I am not logged in
    And I sign in with valid credentials
    When I go to the new_order page
    Then I should see std icon area items
    Then I should see std gear area items

    Then I should see "Request Form" inside "h1"
    Then I should see "Select Supply" inside "option"
    Then I should see field "Dosage"
    Then I should see "Unit" inside "option"
    Then I should see field "Quantity"
    Then I should see field "Special requests for location or dosage"
    Then I should see the button "Submit"
#U#    Then I should see "Add a new supply request"

