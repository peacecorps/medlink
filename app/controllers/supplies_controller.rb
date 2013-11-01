class SuppliesController < ApplicationController
  def index
    @supplies = Supply.all
  end
end

