class Video
  attr_reader :youtube_id

  def initialize youtube_id
    @youtube_id = youtube_id
    freeze
  end

  def youtube_embed_link
    "//www.youtube.com/embed/#{youtube_id}"
  end

  PCV_WELCOME  = new "yTNr0Nh7WYU"
  PCMO_WELCOME = new "KkXb_5kkfwk"
end
