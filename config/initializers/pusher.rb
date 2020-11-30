require 'pusher'
Pusher.app_id =  ENV["PUSHER_APP_ID"] || 1108923
Pusher.key = ENV["PUSHER_KEY"] || '71f4bfd7cbf022661e17'
Pusher.secret = ENV["PUSHER_SECRET"] || '952e604d525c91ca510b'
Pusher.cluster = ENV["PUSHER_CLUSTER"] || 'us2'
Pusher.logger = Rails.logger
Pusher.encrypted = true
