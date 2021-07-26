class CreateTableComprasAdministrationTypes < ActiveRecord::Migration
  def change
    create_table "compras_administration_types" do |t|
      t.string   "description"
      t.string   "administration"
      t.string   "organ_type"
      t.integer  "legal_nature_id"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
    end

    add_index "compras_administration_types", ["legal_nature_id"], :name => "cat_legal_nature_id"
  end
end
