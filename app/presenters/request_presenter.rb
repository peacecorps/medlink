class RequestPresenter < ApplicationPresenter
  delegate :user, :created_at

  def reordered?
    model.reorder_of_id.present?
  end

  def text
    if model.reorder_of_id.present?
      label = "lost package sent #{time_ago_in_words model.reorder_of.created_at} ago"
      path  = h.user_response_path model.user_id, model.reorder_of_id
      "Replacement of #{h.link_to label, path}"
    else
      model.text
    end
  end
end
