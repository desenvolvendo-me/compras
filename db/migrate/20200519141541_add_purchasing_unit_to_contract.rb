class AddPurchasingUnitToContract < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :purchasing_unit_id, :integer
  end
end
