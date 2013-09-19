Feature: Response_to_order Feature
  As a PCMO to the website
  I want to view my pending or past-due request
  So that I can choose what to respond to

# DESIGN DOC TAGS:
#R1, R2, R3, R4 (pg.7) - 4 responses
#B (missing date), C (missing location), D (exc. char
#    limit) ,M (select fulfillment method) (p.8)
#P6 (success) (p.9)
#M1 (EMAIL TEXT) (p.9)

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
    When I go to the start page

  Scenario: View my requests
    Then I should have 6 pending orders to process

#......................................................................
  @wip
  Scenario: View my Pending request
    When I select a "pending" request

    Then I should be able to assign one of four actions: "Delivery"
    Then I should be able to assign one of four actions: "Pickup"
    Then I should be able to assign one of four actions: "Purchase & Reimburse"
    Then I should be able to assign one of four actions: "Special Instructions"
    When I save my response
    Then I should see the response date and PCMO id on the request

#......................................................................

# FIXME: Add Past-Due to cuke test

  @wip
  Scenario: View my Past-Due request
    When I select a "past-due" request

    Then I should be able to assign one of four actions: "Delivery"
    Then I should be able to assign one of four actions: "Pickup"
    Then I should be able to assign one of four actions: "Purchase & Reimburse"
    Then I should be able to assign one of four actions: "Special Instructions"
    When I save my response
    Then I should see the response date and PCMO id on the request

#......................................................................

# FIXME: Add Past-Due to cuke test

  @wip
  Scenario: View my Responded request
    When I select a "responded" request

    Then I should be able to assign one of four actions: "Pickup"
    Then I should be able to assign one of four actions: "Delivery"
    Then I should be able to assign one of four actions: "Pickup"
    Then I should be able to assign one of four actions: "Purchase & Reimburse"
    Then I should be able to assign one of four actions: "Special Instructions"
    When I save my response
    Then I should see the response date and PCMO id on the request

#......................................................................

# FIXME: Do not understand this cuke.

  @wip
  Scenario: Respond to my requests
    When I select a "pending" request
    When I select a "past-due" request

    Then I should be able to assign one of four actions: "Delivery"
    Then I should be able to assign one of four actions: "Pickup"
    Then I should be able to assign one of four actions: "Purchase & Reimburse"
    Then I should be able to assign one of four actions: "Special Instructions"
    When I save my response
    Then I should see the response date and PCMO id on the request

  @wip
  Scenario: Duplicate request
    Given I select a request that another PCMO has responded to
    Then I should see a message that the request has been handled
    Then I should see the other PCMO's id on the request
