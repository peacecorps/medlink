Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

  Background:
    Given the default user exists

  Scenario: User signs in successfully as ADMIN with remember me enabled
    Given I am an "admin"
    And I am not logged in
    When I sign in with valid credentials after checking remember me
    Then I see a successful sign in message
    When I return to the site
    Then I should be signed in as "admin"
    When I close my browser (clearing the session)
    And I return to the site
    Then I should be signed in as "admin"


  Scenario: User clears remember me cookie
    Given I am an "admin"
    And I am not logged in
    When I sign in with valid credentials after checking remember me
    Then I see a successful sign in message
    When I return to the site
    Then I should be signed in as "admin"
    When I clear my remember me cookie and close my browser
    And I return to the site
    Then I should be signed out

