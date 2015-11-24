class Api::V1::BaseController < ActionController::Base
  before_action :json_format
  before_action :api_authenticate!

  private

  def json_format
    request.format = :json
  end

  def api_authenticate!
    @current_user = User.find_by_id ApiAuth.access_id request
    unless @current_user && ApiAuth.authentic?(request, @current_user.secret_key)
      error "You must authorize this request", status: :unauthorized
    end
  end

  def error msg, status: 400
    render json: { error: msg }, status: status
  end
end
