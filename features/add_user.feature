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

    When I choose a country
    Then I should have a pick list of PCMOs in that country

    #first / last name, address, country, pcv_id, pcmo, email and role
    When I fill out the form

    Scenario: missing a required field
      When I miss a required field
      And I click 'Add'
      Then I should see a validation message

    Scenario: entering an invalid email
      When I miss enter an invalid email
      And I click 'Add'
      Then I should see a validation message

    Scenario: adding a duplicate PCV ID
      When I try to enter a duplicate pcv id
      And I click 'Add'
      Then I should see a validation message

    And I click 'Add'
    Then I should see a confirmation dialog
    And the user should be created

#TODO: Scenario: adding a PCMO

#TODO: Scenario: adding an admin
