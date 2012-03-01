class CreateMaterialsProviders < ActiveRecord::Migration
  def change
    create_table :materials_providers, :id => false do |t|
      t.integer :material_id
      t.integer :provider_id
    end

    add_index :materials_providers, :material_id
    add_index :materials_providers, :provider_id

    add_foreign_key :materials_providers, :materials
    add_foreign_key :materials_providers, :providers
  end
end
