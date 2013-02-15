class CustomerFinder
  def initialize(customer_domain, options = {})
    @customer_domain = customer_domain
    @customer_repository = options.fetch(:customer_repository) { Customer }
    @nil_customer_repository = options.fetch(:nil_customer_repository) { NilCustomer }
  end

  def self.current(*params)
    new(*params).current_customer
  end

  def current_customer
    customer_repository.find_by_domain(customer_domain) || nil_customer_repository.new
  end

  private

  attr_reader :customer_domain, :customer_repository, :nil_customer_repository
end
