Feature: Reports
  In order to have medical supplies during the whole deployment
  A user
  Should be able to create reports for replacement medical supplies

  Background:
    Given the default user exists

  @javascript
  Scenario Outline: <user> successfully create report: <report>
    Given I am an "<user>"
    And I am not logged in

    When I sign in with valid credentials
    Then I see a successful sign in message

    When I create a "<report>" report
    When I follow CSV link "<report>"
    And I got the correct "<report>" output
    Then I stay on reports page

    Examples:
      | user  | report        |
      | pcmo  | Order History |

      | admin | Order History |
      | admin | Users         |

# FYI: PCV does not have the report page or any of the 6 reports.
# FYI: pg.13 (PCMO: 3 reports: Supply Requests, Fulfillment History,
#    Request History, ERRORS?)
# FYI: pg.14 (ADMIN: 6 reports: Supply Requests, Fulfillment History, Request
#    History, Recently Added Users, PCMO Response Times, ERRORS?)
