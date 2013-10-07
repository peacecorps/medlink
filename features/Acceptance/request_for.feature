Feature: Request For
  In order to be more flexible with order placement
  A pcmo or admin
  Should be able to submit requests on behalf of a user

  Background:
    Given that "Alabama" is a country
    Given that "Georgia" is a country
    Given that the following supplies exist:
      | shortcode | name  |
      | gz        | Gauze |
    Given that the following pcvs exist:
      | name      | pcv_id | country |
      | alice     | 1      | Alabama |
      | bob       | 2      | Georgia |

  Scenario:
    Given that I am logged in as the pcmo of Alabama
    When I go to the new order page
    Then I should see a pcmo dropdown containing only "alice"

    When I place an order for "alice"
    Then I should see an order for "alice" in the queue

  Scenario:
    Given that I am logged in as an admin
    When I go to the new order page
    Then I should see a pcmo dropdown containing only "alice" and "bob"


