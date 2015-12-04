class MessagesController < ApplicationController
  def index
    authorize :message
    @search   = MessageSearch.new search_params.merge(user: current_user)
    @messages = sort_table do |t|
      t.scope   = @search.messages.includes(current_user.admin? ? { user: :country } : :user)
      t.default = { created_at: :desc }
    end
  end

private

  def search_params
    params[:message_search] || {}
  end
end
