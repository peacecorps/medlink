class RosterUploadFetchJob < ApplicationJob
  def perform upload
    return if upload.fetched?

    url = URI.parse upload.uri
    res = Net::HTTP.get_response url
    if res.code == "200"
      upload.update! body: res.body
    else
      msg = "Failed to pull uploaded CSV #{upload.id} / #{upload.path} (#{res.code})"
      Rails.configuration.slackbot.info msg
      fail msg
    end
  end
end
