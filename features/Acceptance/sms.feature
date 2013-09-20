@wip
Feature: SMS
  In order to have medical supplies during the whole deployment
  A user
  Should be able to submit a request by SMS for replacement medical supplies

  Background:
    Given the default user exists
    Given I am an "<role>"
    When I send a sms request

#----------------------------------------------------------------------
@wip
  Scenario Outline: User successfully requests medical supplies (P5 tag)
  And I give it all the valid sms inputs
    Then I see a successful sms request message

    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
#ERROR/BAD VALUES

# NOTE: Assuming "Special Instructions Area" is optional field.
# NOTE: Unclear how location, qty, and units are bad.

#......................................................................
@wip
  Scenario Outline: Users does not give "Select Supply" value - G (invalid supply)
    And I give it all sms inputs but "Select Supply"
    Then I see a invalid supply sms request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
@wip
  Scenario Outline: User does not give a location value - J  (invalid location)
    And I give it all sms inputs but "location"
    Then I see a invalid Location sms request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
@wip
  Scenario Outline: User does not give a Qty value - I (invalid qty)
    And I give it all sms inputs but "qty"
    Then I see a invalid Qty sms request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
@wip
  Scenario Outline: User does not give a Dose value -- H (invalid dose)
    And I give it all inputs but "dose"
    Then I see a invalid dose sms request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#......................................................................
@wip
  Scenario Outline: User does not give a PCVID value -- F (bad pcvid)
    And I give it all inputs but "bad pcvid"
    Then I see a bad PCVID sms request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

@wip
  Scenario Outline: User gives a bad Quantity value - I (invalid/non-numbers qty)
    And I give it all sms inputs but "invalid Qty"
    Then I see a nonnumber Qty sms request message
    Examples:
      | role  |
      | pcv   |
      | pcmo  |
      | admin |

#FIXME: Scenario: User gives a bad location value. (AL: not validation)
#FIXME: Scenario: User gives a bad dose value. - H (invalid dose) (AL: not validation)

#......................................................................
#OTHER
# TODO: P4(suggorate request), M4 (EMAIL TEXT that goes with P2...)
# TODO/SMS(i guess): 
# L (bad pw)
# TODO: M1 ("EMAIL TEXT that goes with sms message RE1 thru RE4 (msg redundancy)

#TODO: F invalid pcvid
#TODO: M2 - "EMAIL TEXT tha goes with sms message P4) (msg dup)
#TODO: M1 - "EMAIL TEXT tha goes with sms message RE1 to RE4 (msg dup)
