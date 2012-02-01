class CreatePurchaseSolicitationItems < ActiveRecord::Migration
  def change
    create_table :purchase_solicitation_items do |t|
      t.references :purchase_solicitation
      t.references :material
      t.integer :quantity
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.decimal :estimated_total_price, :precision => 10, :scale => 2
      t.boolean :grouped
      t.string :process_number
      t.string :status

      t.timestamps
    end
    add_index :purchase_solicitation_items, :purchase_solicitation_id
    add_index :purchase_solicitation_items, :material_id

    add_foreign_key :purchase_solicitation_items, :purchase_solicitations
    add_foreign_key :purchase_solicitation_items, :materials
  end
end
