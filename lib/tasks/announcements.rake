namespace :announcements do
  desc "Send all scheduled announcements"
  task :send => :environment do
    PeriodicAnnouncementSender.new.send_scheduled
  end
end
