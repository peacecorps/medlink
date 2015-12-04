class UserReminderPresenter < ApplicationPresenter
  def initialize user
    @user            = user
    @latest_reminder = @user.receipt_reminders.newest
    @response = @latest_reminder.try :response
  end

  def expected?
    response && \
      response.model.created_at < 2.weeks.ago && \
      response.delivered_supplies.any?
  end

  def age
    h.time_ago_in_words response.model.created_at
  end

  def response
    TimelineResponsePresenter.new @response if @response
  end
end
