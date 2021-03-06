require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "227b8c921df2cb2f10d79ea995c45c7659c1381369a53d98fead384d844cf048"

  url_format "/media/:job/:name"

  if Rails.env.development? || Rails.env.test?

    datastore :file,
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
    
  else
    datastore :s3,
      region: ENV['S3_BUCKET_REGION'],
      bucket_name: ENV['S3_BUCKET'],
      access_key_id: ENV['S3_KEY_ID'],
      secret_access_key: ENV['S3_SECRET_KEY'],
      url_host: 'demo-shoppingly.siz.yt',
      url_scheme: 'http'
  end
  
  fetch_file_whitelist [              # List of allowed file paths when using fetch_file (strings or regexps)
      /colors/
    ]
  
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
