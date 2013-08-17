Feature: Visit "Forgot Password" Web Page
  As a visitor to the website
  I want to see everything that I expect on the forgot_password_page
  so I can know that the site is working

  Scenario: Check stuff on "Forgot Password" page
    Given I exist as a user
    And I am not logged in
    And I go to the forgot_password page
    Then I should see std icon area items
#TODO: MOBILE VERSION?

    Then I should see "Forgot Password" inside "h2"
    Then I should see "Please enter in your email address and PCVID that we have on file." inside "h3"
    Then I should see "You will receive an email with instructions to help you reset your password." inside "h3"
    Then I should see field "email@email.com"
    Then I should see field "PCV ID"
#TODO: 8/17/2013: ONLY MOBILE:    Then I should see the button "Cancel"
    Then I should see the button "Submit"
