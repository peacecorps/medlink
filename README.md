[![Code Climate](https://codeclimate.com/github/atlrug-rhok/rhok-rails.png)](https://codeclimate.com/github/atlrug-rhok/rhok-rails)

## ATLRUG-RHOK Rails Project Template

This is a no longer blank Rails project that needs a better description than this. To set it up on your machine:

```bash
$ git clone git@github.com:atlrug-rhok/rhok-rails.git
$ bundle
$ rake db:setup
```

and you should be off to the races. You can check by running the specs with

```bash
$ rake spec
```

If it's green, you should be good to go. If you have any questions at all, feel free to email [James](https://github.com/jamesdabbs) or post on the [Google Group](https://groups.google.com/forum/?fromgroups#!forum/atlrug-rhok).

### Ruby version

We're targeting Ruby 1.9.3. If you're running rvm and have 1.9.3 installed, the .rvmrc file should take care of everything.

### Installed Gems

Here's a quick rundown of some Gems you may not be familiar with:

* `haml-rails` - enables rendering of `.html.haml` files, a much less verbose alternative to `.html.erb`. See the [application layout](https://github.com/atlrug-rhok/rhok-rails/blob/master/app/views/layouts/application.html.haml) for an example.
* `pry` - a versatile debugging tool. Drop in a `binding.pry` at any point to halt execution and poke around the application's current state.
* `better_errors` - enables a significantly more informative error page.
* `binding_of_caller` - enables a [REPL](http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) bound at the point of error on the better errors page.

### Rails reference

See the default [README.rdoc](https://github.com/atlrug-rhok/rhok-rails/blob/master/doc/README.rdoc).

### Resque

You'll need to run resque for background jobs (e.g. mailing). Install redis and then

    QUEUE=* bundle exec rake environment resque:work

You can view the status of resque jobs on the resqueweb server at `/resque`.

### Heroku

An instance of this project is live at [http://rhok-rails.herokuapp.com/](http://rhok-rails.herokuapp.com/).

If you would like to be able to deploy to Heroku, add the following to your .git/config:

    [remote "heroku"]
      url = git@heroku.com:rhok-rails.git
      fetch = +refs/heads/*:refs/remotes/heroku/*

Then `git push heroku master` will push your changes to Heroku and trigger a build.

### Pull requests

If you'd like to practice making a pull request, feel free to add yourself to the following list:

## Contributors

* James Dabbs
* Luke J Reimer
* Al Snow
* Clint Lee
