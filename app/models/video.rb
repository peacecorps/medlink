class Video
  def initialize youtube_id
    @youtube_id = youtube_id
    freeze
  end

  def youtube_embed_link
    "//www.youtube.com/embed/#{youtube_id}"
  end

  PCV_WELCOME  = new "qoZvHiSBTAs"
  PCMO_WELCOME = new "4L_XqUhXaMw"

  private

  attr_reader :youtube_id
end
