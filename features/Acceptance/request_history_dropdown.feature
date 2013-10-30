@wip
Feature: "Request History" Web Page's Dropdown
  As a visitor to the website
  I want to filter the "Request History" table using the duration dropdown
  so I can see different data sets based on duration

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
    Given I exist as a user

  Scenario Outline: Admin: Try out the other dropdown values
    And I am a "admin"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    And I select duration "<menu_value>"
    Then I should see dropdownmenu "<menu_value>"
    Then I see 99 lines in the table
    Examples:
    | menu_value     | lines |
    | Previous Month | 99    | 
    | Last 3 Months  | 99    | 
    | Last 6 Months  | 99    | 
    | 1 year         | 99    | 
    | Current Month  | 99    |

  Scenario Outline: PCMO: Try out the other dropdown values
    And I am a "pcmo"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    And I select duration "<menu_value>"
    Then I should see dropdownmenu "<menu_value>"
    Then I see 99 lines in the table
    Examples:
    | menu_value     | lines |
    | Previous Month | 99    | 
    | Last 3 Months  | 99    | 
    | Last 6 Months  | 99    | 
    | 1 year         | 99    | 
    | Current Month  | 99    |

  Scenario Outline: PCV: Try out the other dropdown values
    And I am a "pcv"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    And I select duration "<menu_value>"
    Then I should see dropdownmenu "<menu_value>"
    Then I see 99 lines in the table
    Examples:
    | menu_value     | lines |
    | Previous Month | 99    | 
    | Last 3 Months  | 99    | 
    | Last 6 Months  | 99    | 
    | 1 year         | 99    | 
    | Current Month  | 99    |
