class AddEnvelopeDeliveryTimeToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :licitation_processes, :envelope_delivery_date, :date
    add_column :licitation_processes, :envelope_delivery_time, :time
  end
end
