[![Code Climate](https://codeclimate.com/github/atlrug-rhok/medlink.png)](https://codeclimate.com/github/atlrug-rhok/medlink)
[![Build Status](https://travis-ci.org/atlrug-rhok/medlink.png?branch=master)](https://travis-ci.org/atlrug-rhok/medlink)
[![Coverage Status](https://coveralls.io/repos/atlrug-rhok/medlink/badge.png?branch=master)](https://coveralls.io/r/atlrug-rhok/medlink?branch=master)
[![Ready Stories](http://badge.waffle.io/atlrug-rhok/medlink.png)](http://waffle.io/atlrug-rhok/medlink)

## PC Medlink - Peace Corps Medical Supplies

This project grew out of a [National Day of Civic Hacking](http://hackforchange.org/). You can see a live version of the site at [pcmedlink.org](http://pcmedlink.org).

### Developing locally

If you have any questions at all, feel free to email [James](https://github.com/jamesdabbs) or post on the [Google Group](https://groups.google.com/forum/?fromgroups#!forum/atlrug-rhok).

To get started with a local copy of the project, run

```bash
$ git clone git@github.com:atlrug-rhok/medlink.git
$ bundle
$ rake db:setup
```

and you should be off to the races. You can check your setup by running the specs with

```bash
$ rake spec
```

If it's green, you should be good to go.

A few components require a little extra setup to run:

#### Twilio (SMS integration)

You'll need to sign up for Twilio and set the TWILIO_ACCOUNT_SID, TWILIO_AUTH and TWILIO_PHONE_NUMBER environment variables. If you'd like to receive SMS messages to your local machine, you can set up [localtunnel](http://progrium.com/localtunnel/) and run

```bash
$ localtunnel 3000  # Assuming your development server is running on port 3000
```

and point your Twilio request URL at the address it specifies (http://something.localtunnel.com).

## Contributors

Special thanks to the consulting Peace Corp members, without whom none of this would be possible:
* Patrick Choquette
* Caitlyn Bauer
* Jeffrey Rhodes
* Danel Trisi
* Kevin Sun

Additional thanks to the [RHoK](http://www.rhok.org/) team for their outstanding work getting this project off the ground:
* John Craft
* Jack Craft
* James Dabbs
* Diane Deseta
* Kate Godwin
* Jonathan Howard
* Clint Lee
* Gordon Macie
* Drew Pak
* John Petitte
* Luke J Reimer
* Al Snow
* Patrick Stoica
* Jake Swanson
* Nate Tate
* Laura Moore

We welcome other contributions - just open up an issue or a pull request.
