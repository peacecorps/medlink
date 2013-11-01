Feature: Sign out
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out

  Scenario Outline: User signs out
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    When I sign out
    Then I should see a signed out message
    When I return to the site
    Then I should be signed out
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |
