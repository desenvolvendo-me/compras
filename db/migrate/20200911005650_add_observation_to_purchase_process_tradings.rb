class AddObservationToPurchaseProcessTradings < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_tradings, :observation, :text
  end
end
