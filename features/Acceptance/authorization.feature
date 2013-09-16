Feature: Authorization control
  As a site owner
  I want to be sure to limit access to sensitive areas
  To prevent unauthorized access

#......................................................................

  Scenario Outline: Authorized Page Functionality
    Given I am logged in as a <role>
    When  I go to the <authorized_page> page
    Then  I should not be asked to authenticate with the right credentials

    Examples:
      | role  | authorized_page   | 
      | admin | add user          |
      | admin | admin edit        |

      | user  | new_order         |

      | pcmo  | request_manager   |
      | pcmo  | request history   |
      | pcmo  | reports           |

#......................................................................
@wip
  Scenario Outline: Unauthorized Page Functionality
    Given I am logged in as a <role>
    When  I go to the <unauthorized_page> page
    Then  I should be asked to authenticate with the right credentials

    Examples:
      | role | unauthorized_page | 
      | user | add user          |
      | user | admin edit        |
      | user | response          |
      | user | reports           |

      | pcmo | add user          |
      | pcmo | admin edit        |
