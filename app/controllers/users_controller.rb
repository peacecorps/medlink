class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:current]
  respond_to :json

  def create
  end

  def destroy
  end

  def update
  end

  def index
  end

  def current
    if user_signed_in?
      respond_with current_user
    else
      render :json => {}
    end
  end
end
