class SuppliesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @supplies = Supply.all
  end
end
