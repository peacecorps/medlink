class Slackbot
  class Test
    attr_reader :messages

    def info text, opts={}
      @messages ||= []
      @messages.push text
    end
  end

  attr_reader :subdomain, :token

  def initialize opts={}
    @subdomain = opts.delete(:subdomain) || ENV["SLACK_SUBDOMAIN"]
    @token     = opts.delete(:token)     || ENV["SLACK_TOKEN"]
    @defaults  = opts
  end

  def configured?
    subdomain && token
  end

  def info text, opts={}
    if configured?
      opts[:text] = text
      call "chat.postMessage", @defaults.merge(opts)
    else
      Rails.logger.info "Slackbot: #{text} #{opts}"
    end
  end
  alias_method :error, :info

private

  def call action, opts={}
    Net::HTTP.start("#{subdomain}.slack.com", 443, use_ssl: true) do |http|
      req = Net::HTTP::Post.new("/api/#{action}?t=#{Time.now.to_i}")
      req.set_form_data opts.merge token: token
      http.request(req)
    end
  end
end
