require 'aws-sdk-s3'

Aws.config.update({
  region: ENV['STORAGE_REGION'],
  credentials: Aws::Credentials.new(ENV['STORAGE_ACCESS_KEY_ID'], ENV['STORAGE_SECRET_ACCESS_KEY']),
})

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['STORAGE_BUCKET'])