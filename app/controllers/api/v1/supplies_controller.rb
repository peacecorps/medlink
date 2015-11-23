class Api::V1::SuppliesController < Api::V1::BaseController
  def index
    @supplies = current_user.country.supplies
  end
end
