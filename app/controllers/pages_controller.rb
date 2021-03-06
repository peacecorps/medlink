class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:help, :letsencrypt]
  skip_after_action :verify_authorized

  def root
    if current_user.admin?
      redirect_to admin_root_path
    elsif current_user.pcmo?
      redirect_to manage_orders_path
    else
      redirect_to new_request_path
    end
  end

  def help
    if current_user.nil? || current_user.pcv?
      render 'partials/help'
    else
      render 'partials/pcmo_help'
    end
  end

  def letsencrypt
    c = EncryptChallenge.recent.find_by! pre: params[:id]
    render plain: c.full
  end
end
