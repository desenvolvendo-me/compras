class AddServiceStatusToPurchaseSolicitationLiberation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_liberations, :service_status, :string
  end
end
