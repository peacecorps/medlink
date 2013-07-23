Feature: Visit "Order Table" Web Page
  As a visitor to the website
  I want to see everything that I expect on the order_table page
  so I can know that the site is working

  Scenario: Check stuff on "Order Table" page
    When I go to the order_table page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"
#U#    Then I should see "country" badge
#U#    Then I should see "United States" inside "span"

    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
#U#    Then I should see "Log out" inside "a"

#U#    Then I should see "Requester"
#U#    Then I should see "Request Date"
#U#    Then I should see "Location"
#U#    Then I should see "Requested Supplies"

######################################################################
# Inside one order.
    When I go to the first_order page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
#U#    Then I should see "Log out" inside "a"

#U#    Then I should see "Back to all Orders" (inside span)
#U#    Then I should see "Order Form:" (inside span)
#U#    Then I should see "{name}"
#U#    Then I should see "PCV ID"
#U#    Then I should see "{city}"
#U#    Then I should see "{country}"
#U#    Then I should see "Order Action:" inside "h4"
#U#    Then I should see "Delivered to PCV" inside "label"
#U#    Then I should see "PCV Purchase" inside "label"
#U#    Then I should see "Delivered to Hub" inside "label"
#U#    Then I should see "Special Instructions" inside "label"
#U#    Then I should see field "Message" (placeholder)
#U#    Then I should see "Send"
