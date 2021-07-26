if Rails.env.production? || Rails.env.staging? || Rails.env.training?
  CarrierWave.configure do |config|
    config.storage = :fog

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['S3_KEY'],
      aws_secret_access_key: ENV['S3_SECRET'],
      region: ENV['AWS_REGION']
    }

    config.fog_directory = "integra-#{Rails.env}"
    config.fog_public = false
  end
end
