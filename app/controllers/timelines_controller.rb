class TimelinesController < ApplicationController
  def show
    user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @timeline = Timeline.new user
    authorize @timeline
  end
end
