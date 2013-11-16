Feature: Place a Request for Someone else
  In order to have medical supplies during the whole deployment
  A user
  Should be able to submit a request for replacement medical supplies for someone else

  Background:
    Given that the following supplies exist:
      | shortcode | name  |
      | gz        | Gauze |
    Given the default user exists

#......................................................................
  Scenario Outline: Sunny: User successfully requests medical supplies for someone else (P4 tag: suggorate request)
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I place a request for "<someone_else>"
    And I give it all the valid inputs
    Then I see a successful request message
    And I stay on <afterpage> page
    Examples:
      | role  | afterpage       | someone_else |
      | pcmo  | Request Manager | joe Doe      |
      | admin | Admin Home      | joe Doe      |

#......................................................................
  Scenario Outline: Rainy: Check if no value is select for "Select Volunteer to request for" menu
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I place a request
    And I unselect volunteer
    And I give it all the valid inputs
    Then I see a pcv_id unrecognized message
    Examples:
      | role  |
      | admin |
      | pcmo  |

#......................................................................
  Scenario Outline: Sunny: PCMO location default matches their own
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I place a request
    Then I see "<country>" in the "order_location" input

    When I place a request for "<someone_else>"
    And I give it all the valid inputs
    Then I see a successful request message
    And I stay on <afterpage> page
    Examples:
      | role  | afterpage       | someone_else |  country |
      | pcmo  | Request Manager | joe Doe      |  China   |
