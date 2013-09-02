class SuppliesController < ApplicationController
  before_filter :authenticate_user!

  def index
    #WAS: @supplies = Supply.all
    @supplies = Order.joins(:supply).to_a
  end
end
