class CreateTableComprasRegulatoryActTypes < ActiveRecord::Migration
  def change
    create_table "compras_regulatory_act_types" do |t|
      t.string   "description"
      t.datetime "created_at",                            :null => false
      t.datetime "updated_at",                            :null => false
      t.integer  "regulatory_act_type_classification_id"
    end

    add_index "compras_regulatory_act_types", ["regulatory_act_type_classification_id"], :name => "crat_regulatory_act_type_classification_id"
  end
end
