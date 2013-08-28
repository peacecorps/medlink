Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    Background:
      Given the default user exists

    Scenario: User enters wrong email
      Given I am a "pcv"
      And I am not logged in
      When I sign in with a wrong email
      Then I see an invalid login message
      And I should be signed out

    Scenario: User enters wrong password
      Given I am a "pcmo"
      And I am not logged in
      When I sign in with a wrong password
      Then I see an invalid login message
      And I should be signed out

    Scenario: User signs in successfully as ADMIN
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in as "admin"

    Scenario: User signs in successfully as PCMO
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in as "pcmo"

    Scenario: User is not signed up
      Given I am a "pcv"
      Given I do not exist as a user
      When I sign in with valid credentials
      Then I see an invalid login message
      And I should be signed out
