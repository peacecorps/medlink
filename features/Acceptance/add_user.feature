Feature: Add User
  As an admin to the website
  I want to be able to add users
  So that they can use the system

  Background:
    Given I am logged in as an admin
    And that "Senegal" is a country
    And that "Chad" is a country
    And that the following pcmos exist:
      | name    | country |
      | patrick | Senegal |
      | ricky   | Chad    |
    When  I go to the add user page


  Scenario: successfully adding a user
    Then I should see the add user form

    When I choose a "PCMO" role
    Then I should not see the PCMO select box

    When I choose the country "Chad"
    And  I choose a "Peace Corps Volunteer" role
    Then I should see field "PCMO"
    And  I should see the PCMO select box
    And  I should be able to select from PCMOs in "Chad"

    When I fill out the add user form
    And  I click "Add"
    Then I should see a "Success!" confirmation


  Scenario Outline: validating errors
    When I fill out the add user form
    And  I change <field> to <value>
    And  I click "Add"
    Then I should see a <message> error message

    Examples:
      | field      | value | message  |
      | first_name |       | required |
      | last_name  |       | required |
      | country    |       | required |
      | location   |       | required |
      | phone      |       | required |
      | pcv_id     |       | required |
      | pcv_id     | 11111 | unique   |
      | email      | nope  | invalid  |
