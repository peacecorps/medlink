Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    Background:
      Given the default user exists

#......................................................................
#E1 (invalid email)

    Scenario Outline: User enters wrong email
      Given I am a "<role>"
      And I am not logged in
      When I sign in with a invalid email
      Then I see an invalid email message
      And I should be signed out
      Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
#K (invalid password)

    Scenario Outline: User enters invalid password
      Given I am a "<role>"
      And I am not logged in
      When I sign in with a invalid password
      Then I see an invalid password message
      And I should be signed out
      Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
#E2 (unknown email; not registered)

    Scenario Outline: User enters unknown email (not registered)
      Given I am a "<role>"
      And I am not logged in
      When I sign in with a unknown email
      Then I see an unknown email message
      And I should be signed out
      Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
# SUCCESSFUL LOGIN

    Scenario Outline: User signs in successfully
      Given I am an "<role>"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in as "<role>"
      Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
#E2 (unregistered user/unknown email)

    Scenario Outline: User is not registered
      Given I am a "<role>"
      Given I do not exist as a user
      When I sign in with valid credentials
      Then I see an unregistered email message
      And I should be signed out
      Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
#K (blank/invalid password)

# Was just for PCV.
    Scenario Outline: User enters blank password
      Given I am a "<role>"
      And I am not logged in
      When I sign in with a blank password
      Then I see an blank password message
      And I should be signed out
      Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |
