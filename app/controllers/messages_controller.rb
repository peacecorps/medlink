class MessagesController < ApplicationController
  after_action :verify_authorized

  def new
    @messages = SortTable.new policy_scope(SMS).includes(:user),
      params: params, default: { created_at: :desc }, sort_model: SMS

    @bulk = MessageSender.new
    authorize @bulk
  end

  def create
    @bulk = MessageSender.new(
      body:        send_params[:body],
      country_ids: send_params[:country_ids] || [current_user.country_id]
    )
    authorize @bulk, :send?

    user_count = @bulk.send!
    redirect_to :back, flash: { notice: "Sent messages to #{user_count} users" }
  rescue => e
    redirect_to :back, flash: { danger: "Error in sending - #{e}" }
  end

private

  def send_params
    params.require(:message_sender)
  end
end
