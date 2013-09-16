@wip
Feature: Authorization control
  As a site owner
  I want to be sure to limit access to sensitive areas
  To prevent unauthorized access

  Scenario Outline:
    Given I am logged in as a <role>
    When  I go to the <unauthorized_page> page
    Then  I should be asked to authenticate with the right credentials

    Examples:
      | role | unauthorized_page | 
      | user | add user          |
      | user | admin edit        |
      | user | response          |
      | user | reports           |
      | pcmo | add user          |
      | pcmo | admin edit        |
