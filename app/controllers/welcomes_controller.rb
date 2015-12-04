class WelcomesController < ApplicationController
  def show
    @video = Video.new current_user
    authorize @video
  end

  def update
    video = Video.new current_user
    authorize video
    video.seen!
    redirect_to root_path
  end
end
