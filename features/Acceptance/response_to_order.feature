Feature: Response_to_order Feature
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
      | sally     | 5      | Neverland |
      | john      | 6      | Neverland |
      | peter     | 7      | Neverland |
      | paul      | 8      | Neverland |
    And that the following orders have been made
      | pcv | supply | quantity |
      | 1   | BAC    | 10       |
      | 1   | GEC    | 7        |
      | 2   | BAC    | 9        |
      | 2   | MEL    | 3        |
      | 3   | BAC    | 11       |
      | 3   | CHO    | 8        |
      | 4   | GEC    | 56       |
      | 5   | GEC    | 11       |
      | 6   | MEL    | 22       |
      | 7   | CHO    | 33       |
      | 8   | FRO    | 44       |
    And I am logged in as the pcmo of Quirm
    When I go to the start page

  @javascript
  Scenario: View my requests
#FIXME    Then I should have 3 pending orders to process
#FIXME    Then I should have 3 past due orders to process
    Then I should have 0 response tracker orders

#......................................................................
  @javascript
  Scenario: View my Pending request
    When I select a "pending" request

    Then I should be able to assign one action: "Delivery"
    Then I should be able to assign one action: "Pickup"
    Then I should be able to assign one action: "Purchase & Reimburse"
    Then I should be able to assign one action: "Denial"
    Then I should be able to assign one action: "Special Instructions"
    Then I should be able to assign a special instruction
    When I save my response
    Then I should see the response date and PCMO id "1" on the request

#......................................................................
  @javascript
  Scenario: View my Past-Due request
    When I select a "past-due" request

    Then I should be able to assign one action: "Delivery"
    Then I should be able to assign one action: "Pickup"
    Then I should be able to assign one action: "Purchase & Reimburse"
    Then I should be able to assign one action: "Denial"
    Then I should be able to assign one action: "Special Instructions"
    Then I should be able to assign a special instruction
    When I save my response
#FIXME    Then I should see the response date and PCMO id "2" on the request

# FYI: Scenario: Duplicate request -- You cannot click on already responded orders.

######################################################################
# ERRORS

#......................................................................
  # Tag M (select fulfillment method) (p.8)
  @javascript
  Scenario: Missing Delivery_method
    When I select a "past-due" request
    When I save my response
    Then I should see the missing_delivery_method error message

######################################################################
# VALIDATION

# empty, just-chars, just-digits, special-chars+blanks

  @javascript
  Scenario Outline: Accept empty "Special Instructions" textbox
    When I select a "past-due" request
    Then I should be able to assign one action: "<action>"
    Then I should be able to assign a special instruction of 0 characters
    When I save my response
    Then I should see the success error message
    Examples:
    | action               |
    | Delivery             |
    | Pickup               |
    | Purchase & Reimburse |
    | Denial               |
    | Special Instructions |

  @javascript
  Scenario Outline: Accept "Special Instructions" textbox with 1 character
    When I select a "past-due" request
    Then I should be able to assign one action: "<action>"
    Then I should be able to assign a special instruction of 1 characters
    When I save my response
    Then I should see the success error message
    Examples:
    | action               |
    | Delivery             |
    | Pickup               |
    | Purchase & Reimburse |
    | Denial               |
    | Special Instructions |

  @javascript
  Scenario Outline: Accept "Special Instructions" textbox with ([0-9], " ", special chars).
    When I select a "past-due" request
    Then I should be able to assign one action: "<action>"
    Then I should be able to assign "abcdefghijklmnop 0123456789 !@#$%^&*()_+-={}|:;'<,>.?/~`" to special instruction
    When I save my response
    Then I should see the success error message
    Examples:
    | action               |
    | Delivery             |
    | Pickup               |
    | Purchase & Reimburse |
    | Denial               |
    | Special Instructions |

  # NOTE: "Purchase & Reimburse" has no [] by default.
  @javascript
  Scenario Outline: Check for fogetting to replace the "[word]" in default messages.
    When I select a "past-due" request
    Then I should be able to assign one action: "<action>"
    When I save my response
    Then I should see the replace_placeholder error message
    Examples:
    | action               |
    | Delivery             |
    | Pickup               |
    | Special Instructions |
    | Denial               |

######################################################################
# DESIGN DOC TAGS:
#R1, R2, R3, R4 (pg.7) - 4 responses (DONE)
#P6 (success) (p.9) (DONE)

#TODO -- B (missing date), C (missing location) (p.8)
#TODO -- M1 (EMAIL TEXT) (p.9)
