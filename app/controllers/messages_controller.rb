class MessagesController < ApplicationController
  def index
    authorize :message
    @search   = MessageSearch.new search_params.merge(user: current_user)
    @messages = sort_table do |t|
      t.scope   = @search.messages.includes(current_user.admin? ? { user: :country } : :user)
      t.default = { created_at: :desc }
    end
  end

  def tester
    authorize :message
    @messages = TwilioAccount.null.messages.newest(20)
  end

  def test
    authorize :message
    if current_user.primary_phone
      dispatcher = SMS::Receiver.new twilio: TwilioAccount.null
      dispatcher.handle(from: current_user.primary_phone.number, body: params[:message])
    else
      flash[:notice] = "Please register a phone number to test sending"
    end
    redirect_back fallback_location: tester_messages_path
  end

private

  def search_params
    params.fetch(:message_search, {}).permit(:direction, :direction, :validity, country_ids: [])
  end
end
