Feature: Visit "Sign In" Web Page
  As a visitor to the website
  I want to see everything that I expect on the sign_in_page
  so I can know that the site is working

  Scenario: Check stuff on "Sign In" page
    When I go to the sign_in page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see "Settings" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Logout" inside "a"

#U#    Then I should see "Email" (placeholder)
#U#    Then I should see "Password" (placeholder)
#U#    Then I should see the button "Sign in"
#U#    Then I should see "Sign up" inside "a"
#U#    Then I should see "Forgot your password?" inside "a"
