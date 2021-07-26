class AddDemandIdToPurchaseSolicitation < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitations, :demand_id, :integer
  end
end
