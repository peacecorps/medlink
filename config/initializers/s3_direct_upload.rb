S3DirectUpload.config do |c|
  c.access_key_id     = Figaro.env.s3_access_key_id!
  c.secret_access_key = Figaro.env.s3_secret_access_key!
  c.bucket            = Figaro.env.s3_bucket_name!
end

Aws.config.update(
  region: 'us-east-1',
  credentials: Aws::Credentials.new(
    Figaro.env.s3_access_key_id!,
    Figaro.env.s3_secret_access_key!
  )
)
