class SlackCommandHandler
  def initialize token, params
    @token        = token
    @response_url = params.fetch :response_url
    @text         = params[:text]
    @user_id      = params[:user_id]
    @user_name    = params[:user_name]
  end

  def perform
    intent, content = text.split(/\s+/, 2)
    authenticate intent
    case intent
    when "report"
      ReportUploadJob.perform_later content
    else
      "Unrecognized subcommand: #{intent}"
    end
  rescue StandardError => e
    "Something went wrong while handling `#{@text}`: #{e}"
  end

  private

  attr_reader :token, :response_url, :text, :user_id, :user_name

  def authenticate intent
    unless Figaro.env.SLACK_ADMIN_IDS!.split(",").include?(user_id)
      raise "Unauthorized user: #{user_name} / #{user_id}"
    end
  end

  def respond text
    uri = URI response_url
    Net::HTTP.start uri.host, uri.port, use_ssl: (uri.port == 443) do |http|
      req = Net::HTTP::Post.new uri.path
      req.set_form_data text: text
      http.request req
    end
  end
end
