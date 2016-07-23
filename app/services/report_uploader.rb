class ReportUploader
  Upload = Struct.new :url, :expires_at

  class S3
    def initialize live:
      @bucket = Aws::S3::Resource.new(region: "us-east-1").bucket(Figaro.env.s3_bucket_name!)
      @live   = live
    end

    def call report
      expires_at = 7.days.from_now

      title = report.class.title.gsub /\s+/, '-'
      key   = "reports/#{Rails.env}/#{title}/#{title}-#{Time.now}-#{SecureRandom.uuid}.csv"
      obj   = @bucket.object key

      obj.put(
        body:         report.to_csv,
        expires:      expires_at,
        content_type: "text/csv",
        acl:          "public-read"
      ) if @live

      ReportUploader::Upload.new obj.public_url, expires_at
    end
  end

  def self.build live: true, notifier: nil
    new \
      uploader: ReportUploader::S3.new(live: live),
      notifier: notifier || Medlink.notifier
  end

  def initialize uploader:, notifier:
    @uploader, @notifier = uploader, notifier
  end

  def call report_name
    report_klass = Report.named report_name
    report = report_klass.new report_klass.model
    upload = uploader.call report
    notify report: report, upload: upload
    upload
  end

  private

  attr_reader :uploader, :notifier

  def notify report:, upload:
    notifier.call :new_report_ready, <<-MSG.strip_heredoc
      #{report.class.title} is ready for download at #{upload.url}.
      It will be available until #{upload.expires_at.strftime('%m/%d %H:%M')} }
    MSG
  end
end
