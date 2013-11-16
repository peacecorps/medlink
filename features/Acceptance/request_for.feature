Feature: Request For
  In order to be more flexible with order placement
  A pcmo or admin
  Should be able to submit requests on behalf of a user

  Background:
    Given that "Alabama" is a country
    Given that "Georgia" is a country
    Given that the following supplies exist:
      | shortcode | name  |
      | GAUZE     | Gauze |
    Given that the following pcvs exist:
      | name      | pcv_id | country |
      | alice     | 1      | Alabama |
      | bob       | 2      | Georgia |

  Scenario:
    Given I am logged in as the pcmo of Alabama
    When I go to the new_order page
    Then I should see a pcmo dropdown containing only "alice"
    And I should not see a pcmo dropdown containing "bob"

    When I place an order for "alice"
    Then I should see an order for "alice" in the queue

  Scenario:
    Given I am logged in as an admin
    When I go to the new_order page
    Then I should see a pcmo dropdown containing both "alice" and "bob"
