@touch
Feature: Visit "Sign In" Web Page
  As a visitor to the website
  I want to see everything that I expect on the sign_in_page
  so I can know that the site is working

  Scenario: Check stuff on "Sign In" page (not logged in)
    When I go to the sign_in page
    Then I should see std icon area items

    Then I should see header with text "Sign in"
    Then I should see field "email@email.com"
    Then I should see field "Password"
    Then I should see the button "Sign in"
    Then I should see link "Forgot Password"

