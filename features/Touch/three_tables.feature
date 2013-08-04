Feature: Visit "Three Tables" Web Page
  As a visitor to the website
  I want to see everything that I expect on the three_tables pages
  so I can know that the site is working

TOUCHSTART
  * PCMO - Request Manager
    * Icon, 3 tabs(Request Manager, Place a Request, Reports), Gear
    * "Request Manager" title
      * "Past Due Requests" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request)
      * "Pending Requests" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request)
      * "Response Tracker" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request)

  * Admin - Request Manager
    * Icon, 4 tabs(Admin HomeRequest Manager, Place a Request,
      Reports), Gear
    * "Request Manager" title
    * "Select Country" menu
    * "Past Due Requests" subtitle", table: (PCVID, First Name,
      Last Name, Supply, Dosage, Quantity, Location, Request)
    * "Pending Requests" subtitle", table: (PCVID, First Name,
      Last Name, Supply, Dosage, Quantity, Location, Request)
    * "Response Tracker" subtitle", table: (PCVID, First Name,
      Last Name, Supply, Dosage, Quantity, Location, Request)

  * PCMO - Responded
    * Icon, 3 tabs(Request Manager, Place a Request, Reports),
      Gear, Current Month"
    * "Request Manager" title
      * "Past Due Requests" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request)
      * "Pending Requests" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request)
      * "Response Tracker" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request)

  * Admin - Fulfilled Order
    * Icon, 4 tabs(Admin Home, Request Manager, Place a Request,
      Reports), Gear
    * "Request Manager" title
      * "Past Due Requests" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request)
      * "Pending Requests" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request)
      * "Response Tracker" subtitle", table: (PCVID, First Name,
        Last Name, Supply, Dosage, Quantity, Location, Request,
        Response, Fulfilled, Received)
**AL> Fix "Recived"**
TOUCHEND

  Scenario: Check stuff on "Three Tables: PCMO - Request Manager" pages

  Scenario: Check stuff on "Three Tables: Admin - Request Manager" pages

  Scenario: Check stuff on "Three Tables: PCMO - Responded" pages

  Scenario: Check stuff on "Three Tables: Admin - Fulfilled Order" pages
