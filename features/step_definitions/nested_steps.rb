Then /I should see std icon area items/ do
  steps %{
    Then I should see the image "brand"
    Then I should see header with text "Peace Corps"
    Then I should see header with text "Medical Supplies"
  }
end

Then /I should see non-pcv gear area items/ do
  steps %{
    Then I should see link "Change Password"
    Then I should see link "Help"
    Then I should see link "Sign Out"
  }
end

Then(/^I should see pcv gear area items$/) do
  steps %{
    Then I should see link "Request History"
    Then I should see link "Change Password"
    Then I should see link "Help"
    Then I should see link "Sign Out"
  }
end

Then /I should see std tab area items/ do
  steps %{
    Then I should see tab "Request Manager"
    Then I should see tab "Place a Request"
    Then I should see tab "Reports"
  }
end

Then /I should see admin tab area items/ do
  steps %{
    Then I should see std tab area items
    Then I should see link "Admin Home"
  }
end

Then(/^I should see none tab area items$/) do
  # NO TAB for "none"
end
