namespace :announcements do
  desc "Send all scheduled announcements"
  task :send do
    PeriodicAnnouncementSender.new.send_scheduled
  end
end
