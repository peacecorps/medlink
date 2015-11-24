class Api::V1::RequestsController < Api::V1::BaseController
  def create
    request = current_user.requests.new
    request.text = params[:message]
    request.save!

    params[:supply_ids].each do |id|
      supply = Supply.find params[:id]
      request.supplies << supply
    end

    render json: {
      request: {
        created_at: request.created_at,
        supplies: request.orders.map do |o|
          {
            id: o.supply_id,
            response_id: o.response_id,
            response_type: o.delivery_method.try(:title),
            responded_at: o.response.try(:created_at)
          }
        end
      }
    }
  end

  def index
    render json: { requests: "Not implmemented" }
  end
end
