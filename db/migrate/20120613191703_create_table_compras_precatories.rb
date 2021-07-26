class CreateTableComprasPrecatories < ActiveRecord::Migration
  def change
    create_table "compras_precatories" do |t|
      t.string   "number"
      t.string   "lawsuit_number"
      t.integer  "provider_id"
      t.date     "date"
      t.date     "judgment_date"
      t.date     "apresentation_date"
      t.integer  "precatory_type_id"
      t.text     "historic"
      t.datetime "created_at",                                        :null => false
      t.datetime "updated_at",                                        :null => false
      t.decimal  "value",              :precision => 10, :scale => 2
    end

    add_index "compras_precatories", ["precatory_type_id"], :name => "cp_precatory_type_id"
    add_index "compras_precatories", ["provider_id"], :name => "cpre_provider_id"
  end
end
