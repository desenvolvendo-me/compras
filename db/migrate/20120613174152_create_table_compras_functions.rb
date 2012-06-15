class CreateTableComprasFunctions < ActiveRecord::Migration
  def change
    create_table "compras_functions" do |t|
      t.string   "code"
      t.integer  "regulatory_act_id"
      t.string   "description"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
    end

    add_index "compras_functions", ["regulatory_act_id"], :name => "cf_regulatory_act_id"
  end
end
