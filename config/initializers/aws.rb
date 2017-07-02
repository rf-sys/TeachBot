Aws.config.update({
                      region: 'eu-central-1',
                      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
                  })

$bucket = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])


