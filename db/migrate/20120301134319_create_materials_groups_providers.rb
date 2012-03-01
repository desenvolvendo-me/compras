class CreateMaterialsGroupsProviders < ActiveRecord::Migration
  def change
    create_table :materials_groups_providers, :id => false do |t|
      t.integer :materials_group_id
      t.integer :provider_id
    end

    add_index :materials_groups_providers, :materials_group_id
    add_index :materials_groups_providers, :provider_id

    add_foreign_key :materials_groups_providers, :materials_groups
    add_foreign_key :materials_groups_providers, :providers
  end
end
