class Admin::PagesController < AdminController
  def dashboard
    @upcoming_announcements = Announcement.includes(:country).next 5
    @recent_messages        = SMS.incoming.newest 5
  end
end
