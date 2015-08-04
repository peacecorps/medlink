class PagesController < ApplicationController
  skip_before_filter :authenticate_user!, only: :help

  def root
    redirect_to start_page
  end

  def help
    # This is a dumb way to get Bullet to stop complaining without disabling it altogether
    @supplies = Country.find(current_user.country_id).supplies if current_user
    if current_user.nil? || current_user.pcv?
      render 'partials/help'
    else
      render 'partials/pcmo_help'
    end
  end

private

  def start_page
    if current_user.admin?
      new_admin_user_path
    elsif current_user.pcmo?
      manage_orders_path
    else
      new_request_path
    end
  end
end
