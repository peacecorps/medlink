class AnnouncementPresenter < ApplicationPresenter
  decorates Announcement
  delegate :message, :send!

  def initialize country, reaches: nil
    @reaches = reaches
    super country
  end

  def country
    model.country.name
  end

  def reach
    @reaches ? @reaches.fetch(model.country_id) : AnnouncementReachCache.query(model.country_id)
  end

  def preview
    model.schedule.preview if model.schedule
  end

  def last_sent
    if model.last_sent_at
      short_date model.last_sent_at
    else
      "Never"
    end
  end

  def send_button
    opts = { method: :post, class: "btn btn-default" }
    if model.has_been_sent? within: 1.day
      opts.merge! disabled: "disabled", title: "Announcement has been sent too recently to re-send"
    end

    h.link_to h.deliver_announcement_path(model), opts do
      tags \
        h.icon(:send),
        h.content_tag("small", "to #{reach} volunteers")
    end
  end
end
