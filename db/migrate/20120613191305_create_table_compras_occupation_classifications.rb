class CreateTableComprasOccupationClassifications < ActiveRecord::Migration
  def change
    create_table "compras_occupation_classifications" do |t|
      t.string   "code",       :null => false
      t.string   "name",       :null => false
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "compras_occupation_classifications", ["code"], :name => "coc_code"
    add_index "compras_occupation_classifications", ["parent_id"], :name => "coc_parent_id"
  end
end
