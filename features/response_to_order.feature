Feature: Respone_to_order Feature
  As a PCMO to the website
  I want to view my pending or past-due request
  So that I can choose what to respond to

  Background:
    Given that "Quirm" is a country
    Given that "Neverland" is a country
    Given that the following supplies exist:
      | name      | shortcode |
      | Froyo     | FRO       |
      | Geckos    | GEC       |
      | Bacon     | BAC       |
      | Melons    | MEL       |
      | Chocolate | CHO       |
    And that the following pcvs exist:
      | name      | pcv_id | country   |
      | bill      | 1      | Quirm     |
      | ted       | 2      | Quirm     |
      | jennie    | 3      | Quirm     |
      | tink      | 4      | Neverland |
    And that the following orders have been made 
      | pcv | supply | quantity |
      | 1   | BAC    | 10       |
      | 1   | GEC    | 7        |
      | 2   | BAC    | 9        |
      | 2   | MEL    | 3        |
      | 3   | BAC    | 11       |
      | 3   | CHO    | 8        | 
      | 4   | GEC    | 56       |
    And I am logged in as the pcmo of Quirm
    When I go to the pcmo start page

  Scenario: view my requests
    Then I should have 6 orders to process

  @wip
  Scenario: view my pending request
    When I select a "pending" request

    Then I should be able to assign one of four actions: "TBD"
    When I save my response
    Then I should see the response date and PCMO id on the request

  @wip
  Scenario: view my past-due request
    When I select a "past-due" request

    Then I should be able to assign one of four actions: "TBD"
    When I save my response
    Then I should see the response date and PCMO id on the request

  @wip
  Scenario: Respond to my requests
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
