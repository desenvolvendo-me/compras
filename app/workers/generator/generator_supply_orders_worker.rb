class Generator::GeneratorSupplyOrdersWorker
  include Sidekiq::Worker

  def perform(customer_id, generetor_id)
    using_connection_for(customer_id) do
      UnicoAPI::Consumer.set_customer(Customer.find customer_id)
      generetor = Generator::GeneratorSupplyOrder.find(generetor_id)
    end
  end

  def using_connection_for(customer_id, &block)
    Customer.find(customer_id).using_connection(&block)
  end
end
