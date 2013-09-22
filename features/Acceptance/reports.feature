@wip
Feature: Reports
  In order to have medical supplies during the whole deployment
  A user
  Should be able to create reports for replacement medical supplies

  Background:
    Given the default user exists

# pg.13 (3 reports: Supply Requests, Fulfillment History, Request History, ERRORS?)
# pg.14 (6 reports: Supply Requests, Fulfillment History, Request History,
#    Recently Added Users, PCMO Response Times, ERRORS?)

######################################################################

# TODO: Invalid Outputs? (Answer: GIGO)

#......................................................................
  Scenario Outline: <user> successfully create report: <report>
    Given I am an "<user>"
    And I am not logged in

    When I sign in with valid credentials
    Then I see a successful sign in message

    When I create a "<report>" report
    Then I see a successful file download dialog
    And I got the correct "<report>" output
    Then I am finished

    Examples:
      | user  | report                |

      | pcv   | Supply Requests       |
      | pcv   | Fulfillment History   |
      | pcv   | Request History       |

      | pcmo  | Supply Requests       |
      | pcmo  | Fulfillment History   |
      | pcmo  | Request History       |

      | admin | Supply Requests       |
      | admin | Fulfillment History   |
      | admin | Request History       |
      | admin | Recently Added Users  |
      | admin | Recently Edited Users |
      | admin | PCMO Response Times   |

