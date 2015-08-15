class ResponsesController < ApplicationController
  before_filter :initialize_response, only: [:new, :create]
  before_filter :find_response, only: [:show, :archive, :unarchive]

  # Bullet doesn't seem to realize that we _are_ eager loading phones?
  around_action :skip_bullet, only: [:index]
  def index
    authorize :user, :respond?
    @responses = sort_table archived(accessible_responses), sort_model: User, per_page: 10
  end

  def new
    @orders  = sort_table @user.orders.without_responses.includes(:request, :supply)
    @history = sort_table @user.orders.with_responses.includes(:supply)
  end

  def create
    if orders = params[:orders]
      OrderResponder.new(@user, @response).respond response_params, orders
      redirect_to manage_orders_path, flash:
        { success: I18n.t!("flash.response.sent", user: @user.name) }
    else
      redirect_to manage_orders_path, flash:
        { error: I18n.t!("flash.response.none_selected") }
    end
  end

  def show
  end

  def archive
    @response.archive!
    redirect_to responses_path(redir_params), flash:
      { success: I18n.t!("flash.response.archived") }
  end
  def unarchive
    @response.unarchive!
    redirect_to responses_path(redir_params), flash:
      { success: I18n.t!("flash.response.unarchived") }
  end
  def redir_params
    { responses: params[:responses], page: params[:page] }
  end
  helper_method :redir_params

  def mark_received
    response = Response.find params[:id]
    authorize response
    response.orders.each &:mark_received!
    response.archive!
    redirect_to :back
  end

  def flag
    response = Response.find params[:id]
    authorize response
    response.orders.each &:flag!
    redirect_to :back
  end


  private # -----

  def initialize_response
    @user = User.find params[:user_id]
    authorize @user, :respond?
    @response = Response.new user: @user, country: @user.country
  end

  def find_response
    id = params[:response_id] || params[:id]
    @response = Response.find id
    @user     = @response.user
  end

  def response_params
    params.require(:response).permit :extra_text
  end

  def accessible_responses
    current_user.country.responses.includes(user: :phones, orders: :supply)
  end

  def archived responses
    if params[:responses] == "archived"
      responses.where "archived_at IS NOT NULL"
    elsif params[:responses] == "all"
      responses
    else
      responses.where archived_at: nil
    end
  end
end
