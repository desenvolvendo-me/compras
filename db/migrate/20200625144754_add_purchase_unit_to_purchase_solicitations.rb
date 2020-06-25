class AddPurchaseUnitToPurchaseSolicitations < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitations, :purchasing_unit_id, :integer

    add_index :compras_purchase_solicitations, :purchasing_unit_id

    add_foreign_key :compras_purchase_solicitations, :compras_purchasing_units, column: :purchasing_unit_id
  end
end
