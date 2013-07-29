Feature: Visit "Forgot Password" Web Page
  As a visitor to the website
  I want to see everything that I expect on the forgot_password_page
  so I can know that the site is working

  Scenario: Check stuff on "Forgot Password" page

     When I go to the forgot_password page
     Then I should see the image "brand"
     Then I should see "Peace Corps" inside "h1"
     Then I should see "Medical Supplies" inside "h4"

     Then I should see "Change Password" inside "a"
     Then I should see "Help" inside "a"
     Then I should see "Log out" inside "a"

     Then I should see "Forgot your password?" inside "h2"
     Then I should see field "Email"

     Then I should see the button "Send me reset password instructions"
     Then I should see "Sign up" inside "a"
     Then I should see "Sign in" inside "a"
