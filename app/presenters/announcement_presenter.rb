class AnnouncementPresenter < ApplicationPresenter
  decorates Announcement
  delegate :message, :send!

  def self.reaches
    # FIXME: this needs to be a per-request cached value _only_
    # This over-counts (as some volunteers may not have phones), but 1) is more performant and
    #   2) we don't really mind if people over-estimate how many people they're pinging
    @_reaches ||= User.pcv.group(:country_id).count
  end

  def country
    model.country.name
  end

  def reach
    self.class.reaches[model.country_id] || 0
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
