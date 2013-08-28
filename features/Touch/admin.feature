Feature: Visit "Admin Home" Web Page
  As a visitor to the website
  I want to see everything that I expect on the admin_home page
  so I can know that the site is working

  Scenario: Check stuff on "Add User" page
    Given I exist as a user
    And I am a "admin"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the admin home page
    Then I should see std gear area items
    Then I should see std icon area items
    Then I should see admin tab area items

    Then I should see header with text "Add User"
    Then I should see field "First Name"
    Then I should see field "Last Name"
    Then I should see field "Address / location"
    Then I should see field "user_country_id"
    Then I should see field "Phone Number"
    Then I should see field "Email"

    Then I should see field "PCV ID"
    Then I should see dropdownmenu "Assign Role"
    Then I should see the button "Add"

    #EDIT PART
    Then I should see header with text "Edit Account"
#TODO/FIXME:    Then I should see dropdownmenu "Select Volunteer to edit"
    Then I should see the button "Edit"

#----------------------------------------------------------------------

  Scenario: Check stuff on "Edit User" page
    Given I exist as a user
    And I am a "admin"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the admin edit page
    Then I should see std gear area items
    Then I should see std icon area items
    Then I should see admin tab area items

    Then I should see header with text "Edit Account"
    Then I should see field "First Name"
    Then I should see field "Last Name"
    Then I should see field "Address / location"
    Then I should see field "user_country_id"
    Then I should see field "Phone Number"
    Then I should see field "Email"
    Then I should see field "PCV ID"
    Then I should see dropdownmenu "Assign Role"
    Then I should see the button "Edit"
