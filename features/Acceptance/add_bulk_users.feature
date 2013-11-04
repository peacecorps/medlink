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

  Scenario: Succcesfully selecting a file and uploading all good data
    Then I should see the add user form
    Then I should see the button "Upload CSV"
    Then I should see browse button "csv"

  Scenario: Succcesfully selecting a file and uploading some good and some bad data
    When I uploaded a csv file with some good and some bad data
    Then I should download a invalid_users.csv with bad data and error messages

  Scenario: Successfully selecting a file and uploading all good data
    When I uploaded a csv file with all good data
    Then I should not download anything

# RAINY DAY TESTS
  Scenario: Click on "Upload CSV" before selecting a file
    Then I should see the add user form
    When I click "Upload CSV"
    Then I should go back to the add user page
