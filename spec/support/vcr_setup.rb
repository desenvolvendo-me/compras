require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path("../../fixtures/vcr_cassettes", __FILE__)
  c.hook_into :fakeweb
  c.debug_logger = File.open("#{Rails.root}/log/vcr.log", "w")

  c.default_cassette_options = {
    allow_playback_repeats: true,
    record: :new_episodes,
    serialize_with: :json
  }

  c.preserve_exact_body_bytes do |http_message|
    http_message.body.encoding.name == 'ASCII-8BIT' ||
    !http_message.body.valid_encoding?
  end

  c.ignore_request do |request|
    uri = URI(request.uri)
    (uri.port != 8081 && uri.host == "localhost") || (uri.host == "127.0.0.1")
  end

  c.configure_rspec_metadata!
end
