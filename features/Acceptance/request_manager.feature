Feature: Request Manager
  In order to have medical supplies during the whole deployment
  A PCMO or Admin
  Should be able to manager the requests of replacement medical supplies

  Scenario Outline: Basic (non-Admin) Page Behavior
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I go to the request_manager page
    Examples:
      | role  |
      | pcv   |
      | pcmo  |

  Scenario Outline: Sunny: Basic (Admin) Page Behavior
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I go to the request_manager page
    Then I should see dropdownmenu "Select Country"
#TODO (#95#): Select from "Select Country" dropdown menu for Admin.
#TODO (#95#) Proof that you must select a country before all 3 tables appear.
#TODO (#95#) Proof that you must filter the 3 tables by the country selection.
#TODO (#95#) Proof that the 3 tables have more than just your PCV_ID.
    Examples:
      | role  |
      | admin |
