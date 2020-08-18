class CustomerFinder
  def initialize(request, options = {})
    @request = request
    @customer_repository = options.fetch(:customer_repository) { Customer }
  end

  def self.current(*params)
    new(*params).current_customer
  end

  private

  attr_reader :request, :customer_repository
end
