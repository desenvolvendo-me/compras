class CreateTableComprasCnaes < ActiveRecord::Migration
  def change
    create_table "compras_cnaes" do |t|
      t.string   "code"
      t.string   "name"
      t.integer  "risk_degree_id"
      t.datetime "created_at",     :null => false
      t.datetime "updated_at",     :null => false
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
    end

    add_index "compras_cnaes", ["parent_id"], :name => "cc_parent_id"
    add_index "compras_cnaes", ["risk_degree_id"], :name => "cc_risk_degree_id"
  end
end
