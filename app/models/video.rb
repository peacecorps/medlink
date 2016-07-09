class Video
  attr_reader :viewer

  def self.embed link
    "//www.youtube.com/embed/#{link}"
  end

  def initialize viewer
    @viewer = viewer
    freeze
  end

  def youtube_embed_link
    self.class.embed youtube_id
  end

  def seen?
    viewer.admin? ? true : viewer.welcome_video_shown_at.present?
  end

  def seen!
    viewer.update! welcome_video_shown_at: Time.now
  end

  PCV_WELCOME  = "qoZvHiSBTAs"
  PCMO_WELCOME = "4L_XqUhXaMw"

  private

  def youtube_id
    viewer.pcv? ? PCV_WELCOME : PCMO_WELCOME
  end
end
