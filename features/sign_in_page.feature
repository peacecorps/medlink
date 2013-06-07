Feature: Visit "Sign In" Web Page
  As a visitor to the website
  I want to see everything that I expect on the sign_in_page
  so I can know that the site is working

  Scenario: Check stuff on "Sign In" page
    When I go to the sign_in page
    Then I should see the image "brand"
    Then I should see "Peace Corps" inside "h1"
    Then I should see "Medical Supplies" inside "h4"

    Then I should see the button "Sign in"
    Then I should see "Sign up" inside "a"
    Then I should see "Forgot your password?" inside "a"

    Then I should see "About" inside "a"
    Then I should see "Settings" inside "a"
    Then I should see "Help" inside "a"
    Then I should see "Logout" inside "a"

#U# 1020. GETMEDS/TOUCH ANALYSIS (6/6/2013: Created wiki of this content)
#U#    -- General
#U#        -- Icon (flag, "Peace Corps", "Medical Supplies", <country>)
#U#        -- Gear
#U#            -- About (shows table of orders: "#/orders")
#U#                -- 4 columns (Requester, Request Date, Location, Requested Supplies)
#U#            -- Settings (Edit User)
#U#                -1- "Email"
#U#                -2- "Current Password"
#U#                -3- "New Password"
#U#                -4- "Confirm Password"
#U#                -5- country dropdown (list)
#U#            -- Help (shows table of orders: "#/orders")
#U#                -- 4 columns (Requester, Request Date, Location, Requested Supplies)
#U#            -- Logout
#U#    -- SignIn Form  ("users/sign_in#/sign_in")
#U#        -- "Sign in", username, password, "Sign in", "Sign up", "Forgot your password?"
#U#    -- SignUp Form
#U#        -- "Sign Up"
#U#        -- "First Name", "Last Name"
#U#        -- "Email", "Password", "Confirm Password", "PCV ID", "City", Country
#U#        -- "Sign up", "Sign in" "Forgot your password?"
#U#    -- ForgotYourPassword Form
#U#        -- "Forgot your password?"
#U#        -- Email
#U#        -- "Send me reset password instructions" button
#U#        -- "Sign in", "Sign up"
#U#    -- "#/orders/new"
#U#        -- Icon
#U#        -- Number
#U#        -- "Select Medical Supply" dropdown (list)
#U#        -- Fields: Dosage, Unit, Quantity
#U#        -- "Special request for location or dosage"
#U#        -- "Add a new supply request" button (duplicates the entry form)
#U#	-- Send button
#U#    -- Inside table lines (#/orders/<digit>)
#U#        -- "Back to all Orders" button
#U#        -- Order From: <number>
#U#        -- <city>, <country>
#U#        -- <number>    <name>    <quantity, like 30mg>
#U#        -- Order Action:
#U#        -- 5 radio buttons: "Delivered to PCV", "PCV Purchase",
#U#            "Delivered to Hub", "Contact PCMO", "Other"
#U#        -- Message box (160 chars)
#U#        -- Send button
