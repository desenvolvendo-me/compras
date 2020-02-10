class Generator::GeneratorSupplyOrdersWorker
  include Sidekiq::Worker
  include CustomerHandleConnection

  def perform(customer_id, generetor_id)
    using_connection_for(customer_id) do
      generetor = Generator::GeneratorSupplyOrder.find(generetor_id)
      generetor.create_supply_orders
    end
  end

end
