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
end

task :report => ["report:run"]
