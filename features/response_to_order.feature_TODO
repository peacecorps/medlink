Feature: TBD
  As a PCMO to the website
  I want to get pending or past-due request
  So I can remove these todos.

  Scenario: Request
    #Given I'm a PCMO
    Given I exist as a user
    And I am a "pcmo"
    And I am not logged in
    And I sign in with valid credentials

    #FIXME: Make sure PCMO goes to request_manager page by default.
    #When I'm on my pcmo start page
    When I go to the pcmo start page
    When I select a "pending" request
    When I select a "past-due" request

    Then I should be able to assign one of four actions: "TBD"
    When I save my response
    Then I should see the response date and PCMO id on the request

  Scenario: Duplicate request
    Given I select a request that another PCMO has responded to
    Then I should see a message that the request has been handled
    Then I should see the other PCMO's id on the request
