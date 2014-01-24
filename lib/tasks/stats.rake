# Adding Cucumber features to be reported by the command:
# rake stats
# But e.g. in production environment we probably don't have rspec-rails, nor it's
# statsetup task, we could extend. So lets check if stasetup is available and only
# then extend it. If it isn't then just do nothing.

if Rake::Task.task_defined? 'spec:statsetup'
  Rake::Task['spec:statsetup'].enhance do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << %w(Cucumber\ features features) if File.exist?('features')
    ::CodeStatistics::TEST_TYPES << 'Cucumber features' if File.exist?('features')
  end
end
