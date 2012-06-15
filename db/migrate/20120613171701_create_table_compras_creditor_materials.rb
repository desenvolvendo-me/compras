class CreateTableComprasCreditorMaterials < ActiveRecord::Migration
  def change
    create_table "compras_creditor_materials" do |t|
      t.integer "creditor_id"
      t.integer "material_id"
    end

    add_index "compras_creditor_materials", ["creditor_id"], :name => "ccm_creditor_id"
    add_index "compras_creditor_materials", ["material_id"], :name => "ccm_material_id"
  end
end
