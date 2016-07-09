class SlackController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token, only: [:command]
  skip_after_action :verify_authorized, only: [:command]

  def command
    response = SlackCommandHandler.new(
      Figaro.env.SLACK_COMMAND_TOKEN!, params
    ).perform

    if response.is_a?(String)
      render plain: response
    else
      head :ok
    end
  end
end
