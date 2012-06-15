class CreateTableComprasMaterials < ActiveRecord::Migration
  def change
    create_table "compras_materials" do |t|
      t.integer  "materials_class_id"
      t.string   "code"
      t.string   "description"
      t.text     "detailed_description"
      t.integer  "minimum_stock_balance"
      t.integer  "stock_balance"
      t.decimal  "unit_price",                  :precision => 10, :scale => 2
      t.decimal  "cash_balance",                :precision => 10, :scale => 2
      t.integer  "reference_unit_id"
      t.string   "manufacturer"
      t.boolean  "perishable",                                                 :default => false
      t.boolean  "storable",                                                   :default => false
      t.boolean  "combustible",                                                :default => false
      t.string   "material_characteristic"
      t.integer  "service_or_contract_type_id"
      t.string   "material_type"
      t.datetime "created_at",                                                                    :null => false
      t.datetime "updated_at",                                                                    :null => false
      t.integer  "expense_nature_id"
    end

    add_index "compras_materials", ["expense_nature_id"], :name => "cm_expense_nature_id"
    add_index "compras_materials", ["materials_class_id"], :name => "cm_materials_class_id"
    add_index "compras_materials", ["reference_unit_id"], :name => "cm_reference_unit_id"
    add_index "compras_materials", ["service_or_contract_type_id"], :name => "cm_service_or_contract_type_id"
  end
end
