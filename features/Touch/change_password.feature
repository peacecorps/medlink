@touch
Feature: Visit "Change Password" Web Page
  As a visitor to the website
  I want to see everything that I expect on the change_password page
  so I can know that the site is working

  Scenario: Check stuff on PCV "Change Password" page
    Given I exist as a user
    And I am a "pcv"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the change_password page
    Then I should see std icon area items
    Then I should see std gear area items

    Then I should see header with text "Change Password"
    Then I should see field "Current Password"
    Then I should see field "New Password"
    Then I should see field "Password Confirmation"
    Then I should see the button "Update"

  Scenario: Check stuff on PCMO "Change Password" page
    Given I exist as a user
    And I am a "pcmo"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the change_password page
    Then I should see std icon area items
    Then I should see std gear area items
    Then I should see std tab area items

    Then I should see header with text "Change Password"
    Then I should see field "Current Password"
    Then I should see field "New Password"
    Then I should see field "Password Confirmation"
    Then I should see the button "Update"

  Scenario: Check stuff on Admin "Change Password" page
    Given I exist as a user
    And I am a "admin"
    And I am not logged in
    And I sign in with valid credentials
    When I go to the change_password page
    Then I should see std icon area items
    Then I should see std gear area items
    Then I should see admin tab area items

    Then I should see header with text "Change Password"
    Then I should see field "Current Password"
    Then I should see field "New Password"
    Then I should see field "Password Confirmation"
    Then I should see the button "Update"
