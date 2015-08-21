class MessagesController < ApplicationController
  def index
    authorize :message
    @search   = MessageSearch.new search_params.merge(user: current_user)
    @messages = sort_table \
      @search.messages.includes(current_user.admin? ? { user: :country } : :user),
      default: { created_at: :desc }
  end

private

  def search_params
    params[:message_search] || {}
  end
end
