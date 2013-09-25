Feature: Request Manager
  In order to have medical supplies during the whole deployment
  A PCMO or Admin
  Should be able to manager the requests of replacement medical supplies

  Scenario Outline: Basic Page Behavior
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I go to the request_manager page
#TODO: Select from "Select Country" dropdown menu for Admin.
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |
