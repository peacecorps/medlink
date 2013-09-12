Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    Background:
      Given the default user exists

#......................................................................
#E1 (invalid email)

    Scenario: User enters wrong email
      Given I am a "pcv"
      And I am not logged in
      When I sign in with a invalid email
      Then I see an invalid email message
      And I should be signed out

    Scenario: User enters wrong email
      Given I am a "pcmo"
      And I am not logged in
      When I sign in with a invalid email
      Then I see an invalid email message
      And I should be signed out

    Scenario: User enters wrong email
      Given I am a "admin"
      And I am not logged in
      When I sign in with a invalid email
      Then I see an invalid email message
      And I should be signed out

#......................................................................
#K (invalid password)

    Scenario: User enters invalid password
      Given I am a "pcv"
      And I am not logged in
      When I sign in with a invalid password
      Then I see an invalid password message
      And I should be signed out

    Scenario: User enters invalid password
      Given I am a "pcmo"
      And I am not logged in
      When I sign in with a invalid password
      Then I see an invalid password message
      And I should be signed out

    Scenario: User enters invalid password
      Given I am a "admin"
      And I am not logged in
      When I sign in with a invalid password
      Then I see an invalid password message
      And I should be signed out

#......................................................................
#K (blank/invalid password)

    Scenario: User enters blank password
      Given I am a "pcv"
      And I am not logged in
      When I sign in with a blank password
      Then I see an blank password message
      And I should be signed out

#......................................................................
#E2 (unknown email; not registered)

    Scenario: User enters unknown email (not registered)
      Given I am a "pcv"
      And I am not logged in
      When I sign in with a unknown email
      Then I see an unknown email message
      And I should be signed out

    Scenario: User enters unknown email (not registered)
      Given I am a "pcmo"
      And I am not logged in
      When I sign in with a unknown email
      Then I see an unknown email message
      And I should be signed out

    Scenario: User enters unknown email (not registered)
      Given I am a "admin"
      And I am not logged in
      When I sign in with a unknown email
      Then I see an unknown email message
      And I should be signed out

#......................................................................
#E2 (unregistered user/unknown email)

    Scenario: User is not registered
      Given I am a "pcv"
      Given I do not exist as a user
      When I sign in with valid credentials
      Then I see an unregistered email message
      And I should be signed out

    Scenario: User is not registered
      Given I am a "pcmo"
      Given I do not exist as a user
      When I sign in with valid credentials
      Then I see an unregistered email message
      And I should be signed out

    Scenario: User is not registered
      Given I am a "admin"
      Given I do not exist as a user
      When I sign in with valid credentials
      Then I see an unregistered email message
      And I should be signed out

#......................................................................
# SUCCESSFUL LOGIN

    Scenario: User signs in successfully as PCV
      Given I am an "pcv"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in as "pcv"

    Scenario: User signs in successfully as PCMO
      Given I am an "pcmo"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in as "pcmo"

    Scenario: User signs in successfully as ADMIN
      Given I am an "admin"
      And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in as "admin"

