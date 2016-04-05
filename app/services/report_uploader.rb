class ReportUpload
  attr_reader :url, :expires_at

  def initialize report
    @report = report
  end

  def upload
    @expires_at = 7.days.from_now

    title = @report.class.title.gsub(/\s+/, '-')
    key   = "reports/#{Rails.env}/#{title}/#{title}-#{Time.now}-#{SecureRandom.uuid}.csv"

    s3  = Aws::S3::Resource.new region: "us-east-1"
    obj = s3.bucket(Figaro.env.s3_bucket_name!).object(key)

    contents = @report.to_csv
    obj.put(
      body:         contents,
      expires:      @expires_at,
      content_type: "text/csv",
      acl:          "public-read"
    )

    @url = obj.public_url
  end
end

class ReportUploader
  def initialize report_name
    @report_klass = Report.named report_name
  end

  def run!
    report = generate_report
    upload = send_upload report
    notify report: report, upload: upload
    upload
  end

  private

  def generate_report
    @report_klass.new @report_klass.model
  end

  def send_upload report
    ReportUpload.new(report).tap &:upload
  end

  def notify report:, upload:
    Notification.send :new_report_ready, %{
      #{report.class.title} is ready for download at #{upload.url}.
      It will be available until #{upload.expires_at.strftime('%m/%d %H:%M')} }
  end
end
