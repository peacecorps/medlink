Feature: Visit "Sign In" Web Page
  As a visitor to the website
  I want to see everything that I expect on the sign_in_page
  so I can know that the site is working

  Scenario: Check stuff on "Sign In" page
    When I go to the sign_in page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Log out" inside "a"

    Then I should see "Sign in" inside "h3"
    Then I should see field "Email"
    Then I should see field "Password"
    Then I should see the button "Sign in"
    Then I should see "Sign up" inside "a"
    Then I should see "Forgot your password?" inside "a"
