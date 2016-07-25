module Notification
  class NewReportReady < Notification::Base
    def initialize report:, upload:
      @report, @upload = report, upload
    end

    def slack
      <<-MSG.strip_heredoc
        #{@report.class.title} is ready for download at #{@upload.url}.
        It will be available until #{@upload.expires_at.strftime('%m/%d %H:%M')} }
      MSG
    end
  end
end
