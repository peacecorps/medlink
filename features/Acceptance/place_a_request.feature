Feature: Place a Request 
  In order to have medical supplies during the whole deployment
  A user
  Should be able to submit a request for replacement medical supplies

  Background:
    Given that the following supplies exist:
      | shortcode | name  |
      | gz        | Gauze |
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request

#......................................................................
  Scenario Outline: Users does not give "Select Supply" value - G (invalid supply)
    When I give it all inputs but "Select Supply"
    Then I see a invalid supply request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#----------------------------------------------------------------------
  Scenario Outline: User successfully requests medical supplies (P9 tag)
    When I place a request
    And I give it all the valid inputs
    Then I see a successful request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
#ERRORS
# NOTE: Assuming "Special Instructions Area" is optional field.
# NOTE: Unclear how location, qty, and units are bad.

#......................................................................
  Scenario Outline: User does not give a location
      When I place a request
#FIXME    And I give it all inputs but location
#FIXME    Then I see a invalid "Location" request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
  Scenario Outline: User does not give a Quantity - I (invalid qty)
    When I place a request
#FIXME    And I give it all inputs but quantity
#FIXME    Then I see a invalid "Quantity" request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
  Scenario Outline: User does not give a Units -- H (invalid unit)
    When I place a request
#FIXME    And I give it all inputs but units
#FIXME    Then I see a invalid "Units" request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
#ERROR/BAD VALUES

  Scenario Outline: User gives a bad Quantity value. - I (invalid/non-numbers qty)
    And I give it all inputs with non-number "Quantity"
    Then I see a nonnumber "Quantity" request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#FIXME: Scenario: User gives a bad location value. (AL: not validation)
#FIXME: Scenario: User gives a bad units value. - H (invalid unit) (AL: not validation)

#......................................................................
#OTHER
# TODO: P4(suggorate request), M4 (EMAIL TEXT that goes with P2...)
# TODO/SMS(i guess): F (bad pcvid), L (bad pw)
# TODO: M1 ("EMAIL TEXT that goes with sms message RE1 thru RE4 (msg redundancy)
