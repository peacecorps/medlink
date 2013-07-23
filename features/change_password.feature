Feature: Visit "Change Password" Web Page
  As a visitor to the website
  I want to see everything that I expect on the change_password page
  so I can know that the site is working

  Scenario: Check stuff on "Change Password" page
    When I go to the change_password page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"
#U#    Then I should see "United States"

    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Log out" inside "a"

#U# ********** NOTE: MUST BE LOGGED IN FIRST ********************
#U#    Then I should see "Al Snow"
#U#    Then I should see "12345678"
#U#    Then I should see "jasnow@hotmail.com" (Name/placeholder)
#U#    Then I should see "4049390122" (Phone/placeholder)
#U#    Then I should see "Roswell" (City/placeholder)
#U#    Then I should see "Current Password" (placeholder)
#U#    Then I should see "New Password" (placeholder)
#U#    Then I should see "Password Confirmation" (placeholder)
