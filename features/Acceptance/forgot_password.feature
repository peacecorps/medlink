Feature: Forgot Password
  In order to get access to forgotten password on the site
  A user
  Should be able to get the password by

    Background:
      Given the default user exists

# TODO: missing M3: "System Generated PCV Confirmations"
# TODO: missing M3: "EMAIL TEXT THAT GOES ALONG WITH P3 - password text"

#......................................................................
# E1 (invalid email)

    Scenario: PCV asks for forgotten password with invalid email
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give an invalid email
      Then I see a invalid forgot password email message

    Scenario: PCMO asks for forgotten password with invalid email
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give an invalid email
      Then I see a invalid forgot password email message

    Scenario: ADMIN asks for forgotten password with invalid email
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give an invalid email
      Then I see a invalid forgot password email message

#......................................................................
# F (invalid pcmo)

    Scenario: PCV asks for forgotten password with invalid pcvid
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give an invalid pcvid
      Then I see a invalid forgot password pcvid message

    Scenario: PCMO asks for forgotten password with invalid pcvid
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give an invalid pcvid
      Then I see a invalid forgot password pcvid message

    Scenario: ADMIN asks for forgotten password with invalid pcvid
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give an invalid pcvid
      Then I see a invalid forgot password pcvid message

#......................................................................
# P3 (success)

    Scenario: PCV asks for forgotten password with all valid inputs
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give all valid inputs
      Then I see a successful message

    Scenario: PCMO asks for forgotten password with all valid inputs
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give all valid inputs
      Then I see a successful message

    Scenario: ADMIN asks for forgotten password with all valid inputs
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

      When I ask for a forgotten password
      And I give all valid inputs
      Then I see a successful message
