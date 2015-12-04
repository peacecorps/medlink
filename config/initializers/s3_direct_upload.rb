S3DirectUpload.config do |c|
  c.access_key_id     = Figaro.env.s3_access_key_id!
  c.secret_access_key = Figaro.env.s3_secret_access_key!
  c.bucket            = Figaro.env.s3_bucket_name!
end unless ENV["CI"]
