class RosterUploadFetchJob < ApplicationJob
  def perform upload
    return if upload.fetched?

    body = fetch_body id: upload.id, url: upload.uri
    upload.update! body: body
  end

  private

  def fetch_body id:, url:
    url = URI.parse url

    Net::HTTP.start url.host, url.port, use_ssl: url.scheme == 'https' do |http|
      request = Net::HTTP::Get.new url
      http.request request do |response|
        if response.code != "200"
          raise RosterUpload::FetchFailed,
            "Failed to pull uploaded CSV #{id} / #{url} (#{response.code})"
        end

        body = ""
        response.read_body { |chunk| body += chunk }
        begin
          return body.force_encoding('ISO-8859-1').encode('UTF-8')
        rescue Encoding::UndefinedConversionError => e
          raise RosterUpload::FetchFailed,
            "Could not encode upload body (##{id}) - #{e}. Are you sure it's in ISO-8859-1?"
        end
      end
    end
  end
end
