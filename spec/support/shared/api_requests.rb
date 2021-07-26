shared_context "API requests", :api => true, :type => :request do
  def json
    (@json ||= {}).fetch(response.body) {
      JSON.parse(response.body, :symbolize_names => true)
    }
  end

  before do
    host! "api.example.org"
  end
end
