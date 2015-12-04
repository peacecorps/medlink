class RequestPresenter < ApplicationPresenter
  delegate :user, :created_at

  def reordered?
    model.reorder_of_id.present?
  end

  def text
    if model.reorder_of_id.present?
      label = "lost package sent #{h.time_ago_in_words model.reorder_of.created_at} ago"
      path  = h.response_path model.reorder_of_id
      "Replacement of #{h.link_to label, path}"
    else
      model.text
    end
  end
end
