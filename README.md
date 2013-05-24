= ATLRUG-RHOK Rails Project Template

This is a more-or-less blank Rails project, designed to get members of the ATLRUG-RHOK team on the same page and ready to code ASAP. To set it up on your machine:

```bash
$ git clone git@github.com:atlrug-rhok/rhok-rails.git
$ bundle
$ rake db:setup
```

and you should be off to the races. You can check by running the specs with

```bash
$ rake spec
```

If it's green, you should be good to go. If you have any questions at all, feel free to email James or post on the Google Group.

=== Ruby version

We're targeting Ruby 1.9.3. If you're running rvm and have 1.9.3 installed, the .rvmrc file should take care of everything.

=== Installed Gems

Here's a quick rundown of some Gems you may not be familiar with:

* `haml-rails` - enables rendering of `.html.haml` files, a much less verbose alternative to `.html.erb`. See the application layout for an example.
* `pry` - a versatile debugging tool. Drop in a `binding.pry` at any point to halt execution and poke around the application's current state.
* `better_errors` - enables a significantly more informative error page.
* `binding_of_caller` - enables a REPL bound at the point of error on the better errors page.

=== Rails reference

See the default README.rdoc.

=== Pushing to heroku

Add the following to your .git/config:

    [remote "heroku"]
      url = git@heroku.com:rhok-rails.git
      fetch = +refs/heads/*:refs/remotes/heroku/*

Then `git push heroku master` will push your changes to Heroku and trigger a build.
