if ENV["RAILS_ENV"] == "test"
  load File.expand_path "../../spec/support/coverage.rb", __FILE__

  # Unfortunately, a few models load _before_ the spring fork (notably,
  # `User` because of Devise / routing), and we want our coverage
  # metrics to reflect those

  Spring.after_fork do
    # Force a dump of the pre-fork coverage data, to be merged after the
    # fork exits (SimpleCov.merge_timeout is adjustable if needed)
    SimpleCov.result.format!

    # After each run, dump again to merge
    SimpleCov.at_exit do
      SimpleCov.result.format!
      warn "Spring may skew these numbers. See `#{__FILE__}` for details."
    end
  end

  # Make sure we _don't_ dump results from the spring process when it exits
  SimpleCov.at_exit {}
end
