Feature: Request Manager
  In order to have medical supplies during the whole deployment
  A PCMO or Admin
  Should be able to manager the requests of replacement medical supplies

  Background:
    Given that "Quirm" is a country
    Given that "Neverland" is a country
    Given that "Mexico" is a country
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
      | john      | 9      | Quirm     |
      | tink      | 4      | Neverland |
      | sally     | 5      | Neverland |
      | peter     | 7      | Neverland |
      | john      | 6      | Mexico    |
      | paul      | 8      | Mexico    |
    And that the following orders have been made
      | pcv | supply |
      | 1   | BAC    |
      | 1   | GEC    |
      | 2   | BAC    |
      | 2   | MEL    |
      | 3   | BAC    |
      | 3   | CHO    |
      | 4   | GEC    |
      | 5   | GEC    |
      | 6   | MEL    |
      | 7   | CHO    |
      | 8   | FRO    |
      | 9   | FRO    |

  Scenario Outline: Basic (non-Admin) Page Behavior
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I go to the request_manager page
    Examples:
      | role  |
      | pcv   |
      | pcmo  |

  Scenario Outline: Sunny: Basic (Admin) Page Behavior
    Given the default user exists
    Given I am an "<role>"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I go to the request_manager page
    Then I should see dropdownmenu "Select Country"
    When I choose the country "Select Country"

    When I choose the country "Quirm"
    Then I see lines in the past_due table
    Then I see lines in the pending table
    Then I see no lines in the request_tracker table

    When I choose the country "Neverland"
    Then I see lines in the past_due table
    Then I see lines in the pending table
    Then I see no lines in the request_tracker table
    Examples:
      | role  |
      | admin |

