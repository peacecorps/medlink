Feature: Sign in
  In order to changed your password on the site
  A user
  Should be able to have a way to change their passwords

    Background:
      Given the default user exists

#......................................................................
    Scenario: Admin: Wrong current password
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give invalid password
      Then I should see an invalid current password message

    Scenario: PCMO: Wrong current password
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give invalid password
      Then I should see an invalid current password message

    Scenario: PCV: Wrong current password
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give invalid password
      Then I should see an invalid current password message

#......................................................................
    Scenario: Admin: Empty current password
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give blank password
      Then I should see an blank current password message

    Scenario: PCMO: Empty current password
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give blank password
      Then I should see an blank current password message

    Scenario: PCV: Empty current password
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give blank password
      Then I should see an blank current password message

#......................................................................
    Scenario: Admin: (current != new) password confirmation
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give mismatched passwords
      Then I should see a mismatched password message

    Scenario: PCMO: (current != new) password confirmation
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give mismatched passwords
      Then I should see a mismatched password message

    Scenario: PCV: (current != new) password confirmation
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give mismatched passwords
      Then I should see a mismatched password message

#......................................................................
    Scenario: Admin: Too Short Password format
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give too short new password
      Then I should see a too short password message

    Scenario: PCMO: Too Short Password format
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give too short new password
      Then I should see a too short password message

    Scenario: PCV: Too Short Password format
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give too short new password
      Then I should see a too short password message

#......................................................................
    Scenario: Admin successfully changes their password
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give valid password inputs
      Then I should see an account edited message

    Scenario: PCMO successfully changes their password
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give valid password inputs
      Then I should see an account edited message

    Scenario: PCV successfully changes their password
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I give valid password inputs
      Then I should see an account edited message
 
#......................................................................
    Scenario: Tag K: Invalid Password format (really too short)
#TODO:
