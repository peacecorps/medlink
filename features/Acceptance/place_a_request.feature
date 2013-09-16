Feature: Place a Request 
  In order to have medical supplies during the whole deployment
  A user
  Should be able to submit a request for replacement medical supplies

  Background:
    Given the default user exists

#......................................................................
  Scenario: PCV: no Select Supply - G (invalid supply)
    Given I am an "pcv"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
    And I give it all inputs but "Select Supply"
    Then I see a invalid supply request message

  Scenario: PCMO: no Select Supply - G (invalid supply)
    Given I am an "pcmo"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
    And I give it all inputs but "Select Supply"
    Then I see a invalid supply request message

  Scenario: Admin: no Select Supply - G (invalid supply)
    Given I am an "admin"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
    And I give it all inputs but "Select Supply"
    Then I see a invalid supply request message

#----------------------------------------------------------------------
  Scenario: PCV successfully requests medical supplies (P9 tag)
    Given I am an "pcv"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all the valid inputs
#FIXME    Then I see a successful request message

  Scenario: PCMO successfully requests medical supplies (P9 tag)
    Given I am an "pcmo"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all the valid inputs
#FIXME    Then I see a successful request message

  Scenario: Admin successfully requests medical supplies (P9 tag)
    Given I am an "admin"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all the valid inputs
#FIXME    Then I see a successful request message

#......................................................................
#ERRORS
# NOTE: Assuming "Special Instructions Area" is optional field.
# NOTE: Unclear how location, qty, and units are bad.
#......................................................................
  Scenario: PCV: empty location
    Given I am an "pcv"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but location
#FIXME    Then I see a invalid "Location" request message

  Scenario: PCMO: empty location
    Given I am an "pcmo"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but location
#FIXME    Then I see a invalid "Location" request message

  Scenario: Admin: empty location
    Given I am an "admin"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but location
#FIXME    Then I see a invalid "Location" request message

#......................................................................
  Scenario: PCV: empty qty - I (invalid qty)
    Given I am an "pcv"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but quantity
#FIXME    Then I see a invalid "Quantity" request message

  Scenario: PCMO: empty qty - I (invalid qty)
    Given I am an "pcmo"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but quantity
#FIXME    Then I see a invalid "Quantity" request message

  Scenario: Admin: empty qty - I (invalid qty)
    Given I am an "admin"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but quantity
#FIXME    Then I see a invalid "Quantity" request message

#......................................................................
  Scenario: PCV: empty units - H (invalid unit)
    Given I am an "pcv"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but units
#FIXME    Then I see a invalid "Units" request message

  Scenario: PCMO: empty units - H (invalid unit)
    Given I am an "pcmo"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but units
#FIXME    Then I see a invalid "Units" request message

  Scenario: Admin: empty units - H (invalid unit)
    Given I am an "admin"
    And I am not logged in
    When I sign in with valid credentials
    Then I see a successful sign in message
    When I place a request
#FIXME    And I give it all inputs but units
#FIXME    Then I see a invalid "Units" request message

#STOPHERE #############################################################
#ERROR/BAD VALUES

  Scenario: bad location (AL: not validation)
  Scenario: bad qty - I (invalid qty) (AL: not validation)
  Scenario: bad units - H (invalid unit) (AL: not validation)

#......................................................................
#OTHER
# TODO: P4(suggorate request)
# TODO/SMS(i guess): F (bad pcvid), L (bad pw)
# TODO: M1 ("EMAIL TEXT that goes with sms message RE1 thru RE4 (msg redundancy)