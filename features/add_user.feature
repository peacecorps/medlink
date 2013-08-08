@wip
Feature: Add User
  As an admin to the website
  I want to be able to add users
  So that they can use the system

  Background:
    Given I am logged in as an admin
    When I go to the add user page

  Scenario: adding a PCV
    Then I should see the add user form