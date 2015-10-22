namespace :announcements do
  desc "Send all scheduled announcements"
  task :send do
    Announcement.send_scheduled!
  end

  desc "Send receipt reminders to pester volunteers to mark receipt of goods"
  task :receipt_reminders do
    Response.send_receipt_reminders!
  end
end
