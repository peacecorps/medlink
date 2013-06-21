Feature: Visit "Sign Up" Web Page
  As a visitor to the website
  I want to see everything that I expect on the sign_up_page
  so I can know that the site is working

  Scenario: Check stuff on "Sign Up" page
    When I go to the sign_up page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Logout" inside "a"

#U# PROBLEMS
#U#    Then I should see "Sign up" inside "h3"
#U#    Then I should see field "First Name" (placeholder)
#U#    Then I should see field "Last Name" (placeholder)
#U#    Then I should see field "Email" (placeholder)
#U#    Then I should see field "PCV ID" (placeholder)
#U#    Then I should see field "Phone Number" (placeholder)
#U#    Then I should see field "City" (placeholder)
#U#    Then I should see "Country" inside "option" (BROKEN)
#U#    Then I should see field "Password" (placeholder)
#U#    Then I should see field "Password Confirmation" (placeholder)

#U#    Then I should see field "Submit"
#U#    Then I should see "Sign in" inside "a"
#U#    Then I should see "Forgot your password?" inside "a"
