Feature: Visit "Request History" Web Page
  As a visitor to the website
  I want to see everything that I expect on the request_history pages
  so I can know that the site is working

TOUCHSTART
  * PCV - Request History
**AL> Missing ICON in simulation**
    * "Request History" title, Gear
    * table(Supply, Dose, QTY, Request, Response)      

  * PCMO (i think) - Request History
    * Icon, 3 tabs(Request Manager, Place a Request, Reports), Gear      
    * "Request History" title, "Current Month"
    * table(First Name, Last Name, PCVID, Supply,
        Dosage, Quantity, Location, Requested, Fulfilled, Received)
**AL> Fix "Recived"**

  * Admin - Request History
    * Icon, 4 tabs(Admin Home, Request Manager, Place a Request, Reports), Gear
    * "Request History" title, "Current Month" menu, 
        table(First Name, Last Name, PCVID, Supply,
        Dosage, Quantity, Location, Requested, Fulfilled)
TOUCHEND

  Scenario: Check stuff on PCV "Request History" pages

  Scenario: Check stuff on PCMO "Request History" pages

  Scenario: Check stuff on Admin "Request History" pages

