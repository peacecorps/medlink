class Admin::PagesController < ApplicationController
  def dashboard
    authorize :admin, :manage?
    @upcoming_announcements = Announcement.includes(:country).next 5
    @recent_messages        = SMS.incoming.newest 5
  end
end
