class CreateBalanceAdjustmentItems < ActiveRecord::Migration
  def change
    create_table :compras_balance_adjustment_items do |t|
      t.references :material
      t.references :balance_adjustment
      t.integer :quantity
      t.integer :quantity_new

      t.timestamps
    end
  end
end
