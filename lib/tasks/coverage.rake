namespace :coverage do
  desc "Generate a new coverage report"
  task :generate => :environment do
    # TODO: why doesn't Rake::Task["spec"].anything seem to work here?
    system "COVERAGE=true rspec"
  end

  desc "Open coverage report"
  task :open do
    system "which open && open coverage/index.html"
  end
end

task :coverage => ["coverage:generate", "coverage:open"]
