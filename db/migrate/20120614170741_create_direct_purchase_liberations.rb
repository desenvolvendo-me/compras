class CreateDirectPurchaseLiberations < ActiveRecord::Migration
  def change
    create_table :compras_direct_purchase_liberations do |t|
      t.references :direct_purchase
      t.references :employee
      t.string :evaluation
      t.text :description

      t.timestamps
    end
    add_index :compras_direct_purchase_liberations, :direct_purchase_id
    add_index :compras_direct_purchase_liberations, :employee_id
  end
end
