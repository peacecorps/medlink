class Slackbot
  class Test < Slackbot
    attr_reader :requests

    def initialize *args
      @requests = []
      super *args
    end

    def deliver req
      requests.push req
    end

    def messages
      requests.map { |r| text r }
    end

    def last
      text requests.last if requests.any?
    end

    private

    def text request
      URI.unescape request.body.split("&").find { |k| k.start_with? "text" }.split("=").last.gsub("+", " ")
    end
  end

  def self.build opts={}
    subdomain = opts.delete(:subdomain) || ENV["SLACK_SUBDOMAIN"]
    token     = opts.delete(:token)     || ENV["SLACK_TOKEN"]
    requester = opts.delete(:requester)

    new subdomain: subdomain, token: token, requester: requester, defaults: opts
  end

  attr_reader :subdomain, :token

  def initialize subdomain:, token:, requester:, defaults:
    @subdomain, @token, @defaults = subdomain, token, defaults
    @requester = requester || method(:deliver)
  end

  def call text, opts={}
    opts[:text] = text
    request "chat.postMessage", defaults.merge(opts)
  end

private

  attr_reader :defaults, :requester

  def request action, opts={}
    r = Net::HTTP::Post.new("/api/#{action}?t=#{Time.now.to_i}")
    r.set_form_data opts.merge token: token
    requester.call r
  end

  def deliver req
    # :nocov:
    Thread.new do
      Net::HTTP.start("#{subdomain}.slack.com", 443, use_ssl: true) do |http|
        http.request(req)
      end
    end
    # :nocov:
  end
end
