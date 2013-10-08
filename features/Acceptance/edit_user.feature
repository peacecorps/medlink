# @focus
Feature: Edit User
  As an admin to the website
  I want to be able to edit users
  So that they can use the system

  Background:
    Given I am logged in as an admin
    And that "Senegal" is a country
    And that "Chad" is a country
    And that the following pcmos exist:
      | name    | country |
      | patrick | Senegal |
      | ricky   | Chad    |
    When I go to the edit user page
    Then I should see the edit account form

# Tag P8
#......................................................................
  Scenario: successfully editng a user
#TODO: Select from "Select Volunteer to edit" dropdown menu for Admin.
    When I choose a "Peace Corps Medical Officer" role
    When I choose the country "Chad"
    And  I choose a "Peace Corps Volunteer" role
    Then I should see the PCMO select box
    When I fill out the edit user form
    And  I click "Edit"

#......................................................................
  Scenario Outline: Edit User validate errors
    When I fill out the edit user form
    And  I change <field> to <value>
    And  I click "Edit"
    Then I should see a <message> error message
    Examples:
      | field           | value   | message  |
      | user_first_name |         | required |
      | user_last_name  |         | required |
      | user_location   |         | required |
      | user_phone      |         | required |
      | user_email      |         | required |
      | user_email      | nope    | invalid  |
      | user_pcv_id     |         | required |
      | user_role       |         | required |
      | user_country_id | Country | required |
#FIXME:      | user_pcv_id     | 11111   | unique   |
