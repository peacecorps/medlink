Then /I should see std icon area items/ do
  steps %{
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"
  }
end

Then /I should see std gear area items/ do
  steps %{
    Then I should see "Request History" inside "a"
    Then I should see "Change Password" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Sign Out" inside "a"
  }
end

Then /I should see std tab area items/ do
  steps %{
    Then I should see "Request Manager" inside "a"
    Then I should see "Place a Request" inside "a"
    Then I should see "Reports" inside "a"
  }
end

