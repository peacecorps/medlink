Feature: Sign in
  In order to changed your password on the site
  A user
  Should be able to have a way to change their passwords

    Background:
      Given the default user exists
      And I am an "<role>"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message

#......................................................................
    Scenario Outline: User gives wrong current password
      When I give invalid password
      Then I should see an invalid current password message
      Examples:
        | role  |
        | pcv   |
        | pcmo  |
        | admin |

#......................................................................
    Scenario Outline: User give empty current password
      When I give blank password
      Then I should see an blank current password message
      Examples:
        | role  |
        | pcv   |
        | pcmo  |
        | admin |

#......................................................................
    Scenario Outline: User's password and confirmation are not equal
      When I give mismatched passwords
      Then I should see a mismatched password message
      Examples:
        | role  |
        | pcv   |
        | pcmo  |
        | admin |

#......................................................................
    Scenario Outline: User gives too short a password
      When I give too short new password
      Then I should see a too short password message
      Examples:
        | role  |
        | pcv   |
        | pcmo  |
        | admin |

#......................................................................
    Scenario Outline: User successfully changes their password
      When I give valid password inputs
      Then I should see an account edited message
      Examples:
        | role  |
        | pcv   |
        | pcmo  |
        | admin |

#......................................................................
#TODO:    Scenario: Tag K: User gives an invalid password format. (really too short)
