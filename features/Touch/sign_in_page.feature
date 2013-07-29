Feature: Visit "Sign In" Web Page
  As a visitor to the website
  I want to see everything that I expect on the sign_in_page
  so I can know that the site is working

TOUCHSTART
  * General - Icon (flag, "Peace Corps", "Medical Supplies", {country} (sometimes})

  * General (sort-of) - 
    * Gear **(NOTE: Not on SignIn Page)**
      * (NEW, sometimes not there) Request Supply
      * (NEW) Request History
      * Change Password
      * Help
      * Sign Out (was "Log out")

  * desktop - SignIn Form  ("#/users/sign_in")
    * Logo, PCMED link, "Sign In", Email, Password, 
      "Sign In" button, "Forgot Password"

  * mobile - SignIn Form  ("#/users/sign_in")
    * Logo, PCMED link, "Sign In", Email, Password,
      "Sign In" button, "Forgot Password"
TOUCHEND

  Scenario: Check stuff on "Sign In" page
    When I go to the sign_in page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see "Request History" inside "a"
    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Sign Out" inside "a"

    Then I should see "Sign in" inside "h3"
    Then I should see field "Email"
    Then I should see field "Password"
    Then I should see the button "Sign in"
    Then I should see "Sign up" inside "a"
    Then I should see "Forgot Password?" inside "a"

