class CreateTableComprasMaterialsGroupsComprasProviders < ActiveRecord::Migration
  def change
    create_table "compras_materials_groups_compras_providers", :id => false do |t|
      t.integer "materials_group_id"
      t.integer "provider_id"
    end

    add_index "compras_materials_groups_compras_providers", ["materials_group_id"], :name => "cmgcp_materials_group_id"
    add_index "compras_materials_groups_compras_providers", ["provider_id"], :name => "cmgcp_provider_id"
  end
end
