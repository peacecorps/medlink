[![Code Climate](https://codeclimate.com/github/PeaceCorps/medlink.png)](https://codeclimate.com/github/PeaceCorps/medlink)
[![Build Status](https://travis-ci.org/PeaceCorps/medlink.png?branch=master)](https://travis-ci.org/PeaceCorps/medlink)
[![Coverage Status](https://coveralls.io/repos/PeaceCorps/medlink/badge.png?branch=master)](https://coveralls.io/r/PeaceCorps/medlink?branch=master)

## PC Medlink - Peace Corps Medical Supplies

As seen on the White House Office of Science and Technology Blog: [Keeping Volunteers Healthy One Text at a Time](http://www.whitehouse.gov/blog/2014/10/31/keeping-peace-corps-volunteers-healthy-one-text-time-0)
This project grew out of a [National Day of Civic Hacking](http://hackforchange.org/). You can see a live version of the site at [pcmedlink.org](http://pcmedlink.org).

[Volunteer experience video](https://www.youtube.com/watch?v=JeuyFfBBvTs)

[Support Staff experience video](https://www.youtube.com/watch?v=4L_XqUhXaMw)

### Developing locally


If you have never run a Rails project on your machine, you might want to consult [something like this](https://gorails.com/setup/osx/10.10-yosemite) to help get Ruby, Bundler, and the like all setup. If you have any questions at all, feel free to email [James](https://github.com/jamesdabbs) or post on the [Google Group](https://groups.google.com/forum/?fromgroups#!forum/atlrug-rhok).

To get started with a local copy of the project, run

```bash
$ git clone git@github.com:PeaceCorps/medlink.git
$ bundle --without production
$ rake db:setup
```

*Optional* admin setup. Make sure git is [configured](https://help.github.com/articles/set-up-git) globally as this becomes your admin username. 

```bash
$ rake admin:create
```

and you should be off to the races. You can check your setup by running the specs with

```bash
$ rake spec
```

If it's green, you should be good to go. You can also generate a coverage report by running `rake coverage`.

Then create a pull request and we will review it and merge it into the repo.
We also use [Travis](https://travis-ci.org/PeaceCorps/medlink) for Continuous
Integration.


#### BUGS

**If you find a problem with the software**

Please create an email describing the steps to reproduce the software
problem and email it to [support mailing list](mailto:support@pcmedlink.org).


## Contributors

Special thanks to the consulting Peace Corp members, without whom none of this would be possible:
* Patrick Choquette
* Caitlyn Bauer
* Jeffrey Rhodes
* Danel Trisi
* Kevin Sun
* Chenheli Hua

Additional thanks to the [RHoK](http://www.rhok.org/) team for their outstanding work getting this project off the ground:
* John Croft
* Jack Croft
* James Dabbs
* Diane Deseta
* Kate Godwin
* Jonathan Howard
* Clint Lee
* Gordon Macie
* Emily Merwin
* Laura Moore
* Chae O'Keefe
* Drew Pak
* Gerry Pass
* John Petitte
* Luke J Reimer
* Al Snow
* Patrick Stoica
* Jake Swanson
* Nate Tate

We welcome other contributions - just open up an issue or a pull request.
