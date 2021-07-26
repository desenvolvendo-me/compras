class CreateTableComprasDirectPurchaseLiberations < ActiveRecord::Migration
  def change
    create_table "compras_direct_purchase_liberations" do |t|
      t.integer  "direct_purchase_id"
      t.integer  "employee_id"
      t.string   "evaluation"
      t.text     "description"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
    end

    add_index "compras_direct_purchase_liberations", ["direct_purchase_id"], :name => "cdpl_direct_purchase_id"
    add_index "compras_direct_purchase_liberations", ["employee_id"], :name => "cdpl_employee_id"
  end
end
