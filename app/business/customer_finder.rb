class CustomerFinder
  def initialize(request, options = {})
    @request = request
    @customer_repository = options.fetch(:customer_repository) { Customer }
  end

  def self.current(*params)
    new(*params).current_customer
  end

  def current_customer
    customer_repository.find_by_domain!(request.headers['X-Customer'] || request.host)
  end

  private

  attr_reader :request, :customer_repository
end
