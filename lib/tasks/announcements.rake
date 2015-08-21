namespace :announcements do
  desc "Send all scheduled announcements"
  task :send do
    Announcement.send_scheduled!
  end
end
