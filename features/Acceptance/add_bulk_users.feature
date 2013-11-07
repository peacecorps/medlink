# @focus
Feature: Add Bulk Users
  As an admin to the website
  I want to be able to add bulk users
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

  Scenario: Upload CSV Touch test
    Then I should see the add user form
    Then I should see the button "Upload CSV"
    Then I should see browse button "csv"

@wip
  Scenario: GOOD: Successfully selecting a file and uploading all good data
    When I upload a csv file with all valid data for 3 new users
    Then I should not download anything
    Then the number of users should change to 3
    And I should be sent to the add user page

@wip
  Scenario: SOME: Succcesfully selecting a file and uploading some good and some bad data
    When I upload a csv file with some good and some bad user data
    Then I should download a invalid_users.csv with bad data and error messages
    Then the number of users should change to 999999
    And I should be sent to the add user page

@wip
  Scenario: NONE: Succcesfully selecting a file and uploading all bad data
    When I upload a csv file with all bad user data
    Then I should download a invalid_users.csv with bad data and error messages
    Then the number of users should not change
    And I should be sent to the add user page

# RAINY DAY TESTS
  Scenario: Click on "Upload CSV" before selecting a file
    Then I should see the add user form
    When I click "Upload CSV"
    Then I should see a choose csv file first error message
    And I should be sent to the add user page
