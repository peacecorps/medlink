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

  def duplicated?
    duplicated_at.present?
  end

  def denied?
    delivery_method == :denial
  end

  def status
    if duplicated?
      "Duplicated"
    elsif delivery_method.present?
      delivery_method.title
    end
  end

  def name_with_status
    status ? "#{supply.name} (#{status})" : supply.name
  end
end
