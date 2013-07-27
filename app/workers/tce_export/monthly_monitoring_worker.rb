class TceExport::MonthlyMonitoringWorker
  include Sidekiq::Worker

  def perform(customer_id, monthly_monitoring_id)
    using_connection_for(customer_id) do
      UnicoAPI::Consumer.set_customer(Customer.find customer_id)
      monthly_monitoring = TceExport::MonthlyMonitoring.find(monthly_monitoring_id)

      monthly_monitoring.set_file File.open(TceExport::MG::MonthlyMonitoring.generate_zip_file(monthly_monitoring))
    end
  end

  def using_connection_for(customer_id, &block)
    Customer.find(customer_id).using_connection(&block)
  end
end
