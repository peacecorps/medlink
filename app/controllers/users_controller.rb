class UsersController < ApplicationController
  before_filter :authenticate_user!
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
    respond_with current_user
  end
end
