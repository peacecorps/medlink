Feature: Visit Response Web Pages
  As a visitor to the website
  I want to see everything that I expect on the response pages
  so I can know that the site is working

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

  Scenario: Check stuff on PCMO Response page
    Given I am logged in as the pcmo of Quirm
    And I go to the response page
    Then I should see std gear area items
    Then I should see std icon area items

    Then I should see header with text "Order From:"
    Then I should see header with text "Order Action:"
    Then I should see field "Delivery"
    Then I should see field "Pickup"
    Then I should see field "Purchase & Reimburse"
    Then I should see field "Special Instructions"

    Then I should see div with text "Edit Default SMS"
    Then I should see div with text "characters remaining"
    Then I should see field "order_instructions"
    Then I should see the button "Submit"

  Scenario: Check stuff on Admin Response pages
    Given I am logged in as the pcmo of Quirm
    And I am a "admin"
    And I go to the response page
    Then I should see std gear area items
    Then I should see std icon area items
    Then I should see admin tab area items

    Then I should see header with text "Order From:"
    Then I should see header with text "Order Action:"
    Then I should see field "Delivery"
    Then I should see field "Pickup"
    Then I should see field "Purchase & Reimburse"
    Then I should see field "Special Instructions"

    Then I should see div with text "Edit Default SMS"
    Then I should see div with text "characters remaining"
    Then I should see field "order_instructions"
    Then I should see the button "Submit"
