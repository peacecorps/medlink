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

#......................................................................
#ERRORS
# NOTE: Assuming "Special Instructions Area" is optional field.
# NOTE: #190, #189, #170: Unclear how location, qty, and units are bad.
#TODO: #190: Scenario Outline: User does not give a location (AL: Appears to have a default value)
#TODO: #190: Scenario: User gives a bad location value. (AL: not validation)
#TODO: #189/#170: Scenario: User gives a bad units value. - H (invalid unit)(AL: not validation)

#TODO: For pilot, we allow empty unit and quantity. The numbericality validation of quantity only runs when quantity is given.

#......................................................................
  Scenario Outline: User does not give a Quantity - (Allow empty quantity)
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I place a request
    And I give it all inputs but quantity
    Then I should not see a invalid quantity request message
    And I stay on <afterpage> page
    Examples:
      | role  | afterpage       |
      | pcv   | Request Form    |
      | admin | Admin Home      |
      | pcmo  | Request Manager |

#......................................................................
  Scenario Outline: User does not give a Units - (Allow empty unit)
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I place a request
    And I give it all inputs but units
    Then I should not see a invalid units request message
    And I stay on <afterpage> page
    Examples:
      | role  | afterpage       |
      | pcv   | Request Form    |
      | admin | Admin Home      |
      | pcmo  | Request Manager |

#......................................................................
#ERROR/BAD VALUES

  Scenario Outline: User gives a bad Quantity value. - I (invalid/non-numbers qty)
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message

    When I place a request
    And I give it all inputs with non-number "Quantity"
    Then I see a nonnumber quantity request message
    And I stay on <afterpage> page
    Examples:
      | role  | afterpage       |
      | pcv   | Request Form    |
      | admin | Place a Request |
      | pcmo  | Place a Request |
