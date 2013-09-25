@touch
Feature: Visit "Reports" Web Page
  As a visitor to the website
  I want to see everything that I expect on the Reports pages
  so I can know that the site is working

  Scenario: Check stuff on PCMO Reports pages
    Given I exist as a user
    And I am a "pcmo"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the reports page
#FIXME: (2 Request History) Then I should see std gear area items
    Then I should see std icon area items
    Then I should see std tab area items

    Then I should see link "Supply Requests"
    Then I should see link "Fulfillment History"
    Then I should see link "Request History"

  Scenario: Check stuff on Admin Reports pages
    Given I exist as a user
    And I am a "admin"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the reports page
#FIXME: (2 Request History) Then I should see std gear area items
    Then I should see std icon area items
    Then I should see admin tab area items

    Then I should see link "Supply Requests"
    Then I should see link "Fulfillment History"
    Then I should see link "Request History"
    Then I should see link "Recently Added Users"
    Then I should see link "Recently Edited Users"
    Then I should see link "PCMO Response Times"
