class CreateTableComprasMaterialsComprasProviders < ActiveRecord::Migration
  def change
    create_table "compras_materials_compras_providers", :id => false do |t|
      t.integer "material_id"
      t.integer "provider_id"
    end

    add_index "compras_materials_compras_providers", ["material_id"], :name => "cmcp_material_id"
    add_index "compras_materials_compras_providers", ["provider_id"], :name => "cmcp_provider_id"
  end
end
