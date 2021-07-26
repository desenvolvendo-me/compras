class CreateCustomizations < ActiveRecord::Migration
  def change
    create_table :compras_customizations do |t|
      t.string :model
      t.references :state

      t.timestamps
    end

    add_index :compras_customizations, :state_id
    add_foreign_key :compras_customizations, :unico_states, :column => :state_id
  end
end
