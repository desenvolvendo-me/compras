class CreateTableComprasLicitationModalities < ActiveRecord::Migration
  def change
    create_table "compras_licitation_modalities" do |t|
      t.integer  "regulatory_act_id"
      t.string   "description"
      t.decimal  "initial_value",     :precision => 10, :scale => 2
      t.decimal  "final_value",       :precision => 10, :scale => 2
      t.datetime "created_at",                                       :null => false
      t.datetime "updated_at",                                       :null => false
    end

    add_index "compras_licitation_modalities", ["regulatory_act_id"], :name => "clm_regulatory_act_id"
  end
end
