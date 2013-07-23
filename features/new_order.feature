Feature: Visit "New Order" Web Page
  As a visitor to the website
  I want to see everything that I expect on the new_order page
  so I can know that the site is working

  Scenario: Check stuff on "New Order" page
    When I go to the new_order page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"
#U#   Then I should see "United States" inside "span"

    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
#U#    Then I should see "Log out" inside "a"

#U# #PROBLEMS
#    Then I should see "Request Form"
#    Then I should see "Al Snow" (Name)
#    Then I should see "12345678" (PCV ID)
#    Then I should see "Select Supply" inside "option"
#    Then I should see "Dosage" inside "input"
#    Then I should see field "Unit" inside "option"
#    Then I should see link "Quantity"
#    Then I should see "Add a new supply request"
#    Then I should see "Submit" inside "button"
#    Then I should see "Special requests for location or dosage"
