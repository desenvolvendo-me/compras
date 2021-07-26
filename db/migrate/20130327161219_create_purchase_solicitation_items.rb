class CreatePurchaseSolicitationItems < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_items do |t|
      t.integer  :purchase_solicitation_id
      t.integer  :material_id
      t.string   :brand
      t.decimal  :quantity,   :precision => 10, :scale => 2
      t.decimal  :unit_price, :precision => 10, :scale => 2
      t.timestamps
    end

    add_index :compras_purchase_solicitation_items, :purchase_solicitation_id, :name => :cpsi_purchase_solicitation_idx
    add_index :compras_purchase_solicitation_items, :material_id

    add_foreign_key :compras_purchase_solicitation_items, :compras_purchase_solicitations, :column => :purchase_solicitation_id
    add_foreign_key :compras_purchase_solicitation_items, :compras_materials, :column => :material_id

    execute <<-SQL
      INSERT INTO compras_purchase_solicitation_items (purchase_solicitation_id, material_id, brand, quantity, unit_price, created_at, updated_at)
      SELECT b.purchase_solicitation_id, a.material_id, a.brand, a.quantity, a.unit_price, a.created_at, a.updated_at
      FROM compras_purchase_solicitation_budget_allocation_items a
      JOIN compras_purchase_solicitation_budget_allocations b
        ON b.id = a.purchase_solicitation_budget_allocation_id
    SQL
  end
end
