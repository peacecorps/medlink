Feature: Place a Request
  In order to have medical supplies during the whole deployment
  A user
  Should be able to submit a request for replacement medical supplies

  Background:
    Given that the following supplies exist:
      | shortcode | name  |
      | gz        | Gauze |
    Given the default user exists

#......................................................................
  Scenario Outline: User successfully requests medical supplies (P9 tag)
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I place a request
    And I give it all the valid inputs
    Then I see a successful request message
    And I stay on <afterpage> page
    Examples:
      | role  | afterpage       |
      | pcv   | Request Form    |
      | pcmo  | Request Manager |
      | admin | Admin Home      |

#......................................................................
  Scenario Outline: Users does not give "Select Supply" value - G (invalid supply)
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I place a request
    When I give it all inputs but "Select Supply"
    Then I see a invalid supply request message
    And I stay on <afterpage> page
    Examples:
      | role  | afterpage       |
      | pcv   | Request Form    |
      | admin | Place a Request |
      | pcmo  | Place a Request |
