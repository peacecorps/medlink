@wip
Feature: PCADMIN Firewall (story)
  In order to protect admins from accidents
  An Peace Corps Admin
  Should be able to only login if they are inside the firewall

    Scenario: Outside the firewall
      Given I'm outside the firewall
      And I attempt admin login
      And I exist as a user
      And I am a "admin"
      And I am not logged in
      And I sign in with valid credentials

      Then I get an error message: "TODO"
      And I am not logged in

    Scenario: Inside the firewall
      Given I'm inside the firewall
      And I attempt admin login
      And I exist as a user
      And I am a "admin"
      And I am not logged in
      And I sign in with valid credentials

      Then I should see no error
      And I go to the sign_in page