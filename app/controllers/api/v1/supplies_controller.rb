class Api::V1::SuppliesController < Api::V1::BaseController
  skip_after_action :verify_authorized, only: :master_list

  def index
    @supplies = current_user.country.supplies
  end

  def master_list
    @supplies = Supply.all
    render :index
  end
end
