class AnnouncementsController < ApplicationController
  def index
    @announcements = policy_scope(Announcement).order(last_sent_at: :desc).includes(:country)
  end

  def new
    @announcement = Announcement.new country: current_user.country
    authorize @announcement
  end

  def create
    @announcement = Announcement.new announcement_params
    authorize @announcement
    if @announcement.save
      redirect_to announcements_path, notice: I18n.t!("flash.announcement.created")
    else
      render :new
    end
  end

  def edit
    @announcement = Announcement.find params[:id]
    authorize @announcement
  end

  def update
    @announcement = Announcement.find params[:id]
    authorize @announcement
    if @announcement.update announcement_params
      redirect_to announcements_path, notice: I18n.t!("flash.announcement.updated")
    else
      render :edit
    end
  end

  def deliver
    announcement = Announcement.find params[:id]
    authorize announcement
    announcement.send!
    redirect_to :back, notice: I18n.t!("flash.announcement.sent", volunteer_count: announcement.reach)
  end

private

  def announcement_params
    p = params[:announcement]
    if current_user.admin?
      {
        country_id: p[:country_id],
        message:    p[:message],
        schedule: Schedule.new(
          days: p[:days].split(",").map(&:strip),
          hour: p[:hour]
        )
      }
    else
      { country_id: current_user.country_id, message: p[:message] }
    end
  end
end
