class AnnouncementReachCache
  # TODO: this is probably a query object
  def self.query country_id
    User.pcv.where(country_id: country_id).count
  end

  def initialize
    # This over-counts (as some volunteers may not have phones), but 1) is more performant and
    #   2) we don't really mind if people over-estimate how many people they're pinging
    @reaches ||= User.pcv.group(:country_id).count
  end

  def fetch country_id
    @reaches[country_id] || 0
  end
end
