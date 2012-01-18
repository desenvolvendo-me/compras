module ISSIntel
  class Taxpayer
    attr_accessor :attributes

    def initialize(attributes)
      self.attributes = attributes
    end

    def update!
      return if url.nil?

      uri = URI.parse(url)

      request = Net::HTTP::Post.new(uri.path)
      request.basic_auth(username, password)
      request.set_form_data(:data => data)

      result = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
        http.request(request)
      end

      raise "Failure on ISS Intel API (Code #{result.code})" unless result.is_a?(Net::HTTPSuccess)
    end

    protected

    def url
      Setting.fetch("issintel.sync.url")
    end

    def username
      Setting.fetch("issintel.sync.username")
    end

    def password
      Setting.fetch("issintel.sync.password")
    end

    def data
      { :taxpayer => attributes }.to_json
    end
  end
end
