Feature: Visit "Change Password" Web Page
  As a visitor to the website
  I want to see everything that I expect on the change_password page
  so I can know that the site is working

TOUCHSTART
  * PCV - Change Password (Edit User: "#/users/edit")
    * Gear, "Change Password" title, Email, "Current Password",
        "New Password", "Confirm Password", Update button
    * NOTE: Removed phone and city.

  * PCMO - Change Password
    * Icon, 3 tabs(Request Manager, Place a Request, Reports), 
    * Gear, "Change Password" title, Email, "Current Password",
        "New Password", "Confirm Password", Update button

  * Admin - Change Password
    * Icon, 4 tabs(Admin Home, Request Manager, Place a Request,
      Reports)
    * Gear, "Change Password" title, Email, "Current Password",
        "New Password", "Confirm Password", Update button
TOUCHEND

  Scenario: Check stuff on "Change Password" page
    Given I exist as a user
    And I am not logged in
    And I sign in with valid credentials
    When I go to the change_password page
#ICON
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

#GEAR
    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Sign Out" inside "a"

    Then I should see "Change Password" inside "h1"
    Then I should see field "Email"
    Then I should see field "Current Password"
    Then I should see field "New Password"
    Then I should see field "Password Confirmation"
    Then I should see the button "Update"
