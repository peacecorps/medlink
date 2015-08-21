class Slackbot
  attr_reader :subdomain, :token

  def initialize
    @subdomain = ENV["SLACK_SUBDOMAIN"]
    @token     = ENV["SLACK_TOKEN"]
  end

  def configured?
    subdomain && token
  end

  def message text, opts={}
    if configured?
      # :nocov:
      call "chat.postMessage", opts.merge(
        text:       text,
        channel:    "#medlink",
        username:   "Medlink",
        icon_emoji: ":hospital:"
      )
      # :nocov:
    else
      Rails.logger.info "Slackbot: #{text} #{opts}"
    end
  end

private

  def call action, opts={}
    # :nocov:
    Net::HTTP.start("#{subdomain}.slack.com", 443, use_ssl: true) do |http|
      req = Net::HTTP::Post.new("/api/#{action}?t=#{Time.now.to_i}")
      req.set_form_data opts.merge token: token
      http.request(req)
    end
    # :nocov:
  end
end
