namespace :report do
  desc "Run named report"
  task :run, [:name] => :environment do |_,args|
    name   = args[:name] || ENV["NAME"]
    klass  = Report.named name
    report = klass.new klass.model

    print "Writing `#{report.filename}` ... "
    File.write report.filename, report.to_csv
    puts "Done"
  end

  desc "Upload named report"
  task :upload, [:name] => :environment do |_,args|
    name = args[:name] || ENV["NAME"]
    ReportUploader.new(name).run!
    puts "Done"
  end

  desc "Run the start-of-month order report upload"
  task :monthly_upload do
    # The expectation is that this will be on a `daily` schedule on Heroku
    if Date.today == 1
      ReportUploader.new("order history").run!
    end
  end
end

task :report => ["report:run"]
