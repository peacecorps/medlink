class SuppliesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def index
    respond_with Supply.all
  end
end
