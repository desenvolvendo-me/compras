class CreateAdditiveSolicitationItems < ActiveRecord::Migration
  def change
    create_table :compras_additive_solicitation_items do |t|
      t.integer :quantity
      t.decimal :value
      t.references :material
      t.references :additive_solicitation

      t.timestamps
    end
    add_index :compras_additive_solicitation_items, :material_id
  end
end
