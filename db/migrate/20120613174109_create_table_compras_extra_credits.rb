class CreateTableComprasExtraCredits < ActiveRecord::Migration
  def change
    create_table "compras_extra_credits" do |t|
      t.integer  "entity_id"
      t.integer  "year"
      t.string   "credit_type"
      t.datetime "created_at",                                            :null => false
      t.datetime "updated_at",                                            :null => false
      t.integer  "regulatory_act_id"
      t.date     "credit_date"
      t.integer  "extra_credit_nature_id"
      t.decimal  "supplement",             :precision => 10, :scale => 2
      t.decimal  "reduced",                :precision => 10, :scale => 2
    end

    add_index "compras_extra_credits", ["entity_id"], :name => "cec_entity_id"
    add_index "compras_extra_credits", ["extra_credit_nature_id"], :name => "cec_extra_credit_nature_id"
    add_index "compras_extra_credits", ["regulatory_act_id"], :name => "cec_regulatory_act_id"
  end
end
