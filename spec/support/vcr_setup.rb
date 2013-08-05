require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = File.expand_path("../../fixtures/vcr_cassettes", __FILE__)
  c.hook_into :fakeweb
  c.debug_logger = File.open("#{Rails.root}/log/vcr.log", "w")

  c.ignore_request do |request|
    uri = URI(request.uri)
    (uri.port != 8081 && uri.host == "localhost") || (uri.host == "127.0.0.1")
  end
end
