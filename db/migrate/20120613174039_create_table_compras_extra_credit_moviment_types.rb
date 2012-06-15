class CreateTableComprasExtraCreditMovimentTypes < ActiveRecord::Migration
  def change
    create_table "compras_extra_credit_moviment_types" do |t|
      t.integer  "extra_credit_id"
      t.integer  "moviment_type_id"
      t.integer  "budget_allocation_id"
      t.integer  "capability_id"
      t.decimal  "value",                :precision => 10, :scale => 2
      t.datetime "created_at",                                          :null => false
      t.datetime "updated_at",                                          :null => false
    end

    add_index "compras_extra_credit_moviment_types", ["budget_allocation_id"], :name => "cecmt_budget_allocation_id"
    add_index "compras_extra_credit_moviment_types", ["capability_id"], :name => "cecmt_capability_id"
    add_index "compras_extra_credit_moviment_types", ["extra_credit_id"], :name => "cecmt_extra_credit_id"
    add_index "compras_extra_credit_moviment_types", ["moviment_type_id"], :name => "cecmt_moviment_type_id"
  end
end
