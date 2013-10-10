# @focus
Feature: Admin Home then Edit User
  As an admin to the website
  I want to be able to edit users after going to Admin Home page
  So that they can use the system

  Background:
    Given I am logged in as an admin
    When  I go to the add user page

  Scenario: Sunny: Click on "Edit" on Admin Home after selecting user
    When I choose a "joe Doe" edit user
    And  I click "Edit"
    Then I should see the edit account form

  Scenario: Rainy: Click on "Edit" on Admin Home without selecting user
    And  I click "Edit"
    Then I should see a required edit volunteer error message

