class AddSimulatedToPaymentResources < ActiveRecord::Migration
  def change
    add_column :payment_resources, :simulated, :boolean, :default => false
  end
end
