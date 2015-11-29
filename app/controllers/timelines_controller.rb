class TimelinesController < ApplicationController
  def show
    @timeline = Timeline.new User.find params[:user_id]
    authorize @timeline
  end
end
