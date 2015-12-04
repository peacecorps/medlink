class OrderResponsePresenter < ApplicationPresenter
  delegate_all

  def how_past_due
    due    = DueDate.new(model).due
    finish = responded_at || Time.now
    return unless finish > due
    h.distance_of_time_in_words finish, due
  end

  def response_time
    return unless response
    h.distance_of_time_in_words response.created_at, created_at
  end

  def duplicated?
    duplicated_at.present?
  end

  def denied?
    delivery_method == DeliveryMethod::Denial
  end

  def status
    if duplicated?
      "Duplicated"
    elsif delivery_method.present?
      delivery_method.title
    end
  end

  def duplicate_label
    "Updated on #{short_date duplicated_at}"
  end

  def supply
    model.supply.name
  end

  def name_with_status
    status ? "#{supply} (#{status})" : supply
  end

  def timeline_link
    return unless response_id
    h.link_to "##{TimelineResponsePresenter.anchor response_id}" do
      tags \
        delivery_method.try(:title),
        h.content_tag(:small, "#{h.time_ago_in_words responded_at} ago")
    end
  end
end
