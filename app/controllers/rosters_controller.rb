class RostersController < ApplicationController
  def show
    @roster = Roster.new current_user.country
    authorize @roster
  end
end
