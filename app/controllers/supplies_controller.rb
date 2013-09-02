class SuppliesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @supplies = Order.joins(:supply).all
  end
end
