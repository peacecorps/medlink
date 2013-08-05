@wip
Feature: TBD
  As a PCMO to the website
  I want to view my pending or past-due request
  So that I can choose what to respond to

  Background:
    Given I am the PCMO 
    Given that pcv "bill" exists
    Given that pcv "ted" exists
    Given that pcv "jennie" exists
    #Given that "jennie" has created the following requests
    #Given that "bill" has created the following requests
    #Given that "ted" has created the following requests
    When I go to the pcmo start page

  @wip
  Scenario: view my requests
    Then my "pending" requests should have "223344"
    And my "past due" requests should have 2 requests

  @wip
  Scenario: respond to  my requests
    When I select a "pending" request
    When I select a "past-due" request

    Then I should be able to assign one of four actions: "TBD"
    When I save my response
    Then I should see the response date and PCMO id on the request

  @wip
  Scenario: Duplicate request
    Given I select a request that another PCMO has responded to
    Then I should see a message that the request has been handled
    Then I should see the other PCMO's id on the request
