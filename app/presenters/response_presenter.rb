class ResponsePresenter < ApplicationPresenter
  delegate :user, :archived?

  def status_btn
    h.link_to h.response_path(model), class: "btn btn-default" do
      if model.received?
        on "Received", model.received_at
      elsif model.reordered?
        on "Reordered", model.reordered_at
      else
        on "Cancelled", model.cancelled_at
      end
    end
  end

  private

  def on text, date
    tags \
      h.content_tag(:span, text),
      h.content_tag(:small, "on #{short_date date}")
  end
end
