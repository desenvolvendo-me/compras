class CreateTableComprasAdministrativeProcessBudgetAllocationItems < ActiveRecord::Migration
  def change
    create_table "compras_administrative_process_budget_allocation_items" do |t|
      t.integer  "administrative_process_budget_allocation_id"
      t.integer  "material_id"
      t.integer  "quantity"
      t.decimal  "unit_price",                                  :precision => 10, :scale => 2
      t.datetime "created_at",                                                                 :null => false
      t.datetime "updated_at",                                                                 :null => false
      t.integer  "licitation_process_lot_id"
    end

    add_index "compras_administrative_process_budget_allocation_items", ["administrative_process_budget_allocation_id"], :name => "capbai_administrative_process_budget_allocation_id"
    add_index "compras_administrative_process_budget_allocation_items", ["licitation_process_lot_id"], :name => "capbai_licitation_process_lot_id"
    add_index "compras_administrative_process_budget_allocation_items", ["material_id"], :name => "capbai_material_id"
  end
end
