Feature: Visit "Sign Up" Web Page
  As a visitor to the website
  I want to see everything that I expect on the sign_up_page
  so I can know that the site is working

  Scenario: Check stuff on "Sign Up" page
    When I go to the sign_up page
    Then I should see std icon area items
    Then I should see std gear area items

    Then I should see "Sign up" inside "h3"
    Then I should see field "First Name"
    Then I should see field "Last Name"
    Then I should see field "Email"
    Then I should see field "PCV ID"
    Then I should see field "Phone Number"
    Then I should see field "City"
    Then I should see "Country" inside "option"
    Then I should see field "Password"
    Then I should see field "Password Confirmation"
    Then I should see the button "Submit"
