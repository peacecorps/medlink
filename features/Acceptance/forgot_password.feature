Feature: Forgot Password
  In order to get access to forgotten password on the site
  A user
  Should be able to get the password by

  Background:
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I ask for a forgotten password

# TODO: missing M3: "System Generated PCV Confirmations"
# TODO: missing M3: "EMAIL TEXT THAT GOES ALONG WITH P3 - password text"

#......................................................................
# E1 (invalid email)

  Scenario Outline: User asks for forgotten password with invalid email
    When I give an invalid email
    Then I see a invalid forgot password email message
    Examples:
    | role  |
    | pcv   |
    | pcmo  |
    | admin |

#......................................................................
# F (invalid pcmo)

  Scenario Outline: User asks for forgotten password with invalid pcvid
    When I give an invalid pcvid
    Then I see a invalid forgot password pcvid message
    Examples:
    | role  |
    | pcv   |
    | pcmo  |
    | admin |

#......................................................................
# P3 (success)

  Scenario Outline: User asks for forgotten password with all valid inputs
    When I give all valid inputs
    Then I see a successful message
    Examples:
    | role  |
    | pcv   |
    | pcmo  |
    | admin |
