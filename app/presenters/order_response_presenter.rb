class OrderResponsePresenter < Draper::Decorator
  delegate_all

  def how_past_due
    finish = responded_at || Time.now
    return unless finish > due_at
    h.distance_of_time_in_words finish, due_at
  end

  def response_time
    return unless response
    h.distance_of_time_in_words response.created_at, created_at
  end
end
