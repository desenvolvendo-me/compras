class CreateTableComprasMaterialsClassesComprasProviders < ActiveRecord::Migration
  def change
    create_table "compras_materials_classes_compras_providers", :id => false do |t|
      t.integer "materials_class_id"
      t.integer "provider_id"
    end

    add_index "compras_materials_classes_compras_providers", ["materials_class_id"], :name => "cmccp_materials_class_id"
    add_index "compras_materials_classes_compras_providers", ["provider_id"], :name => "cmccp_provider_id"
  end
end
