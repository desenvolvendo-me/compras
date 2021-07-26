class CreateTableComprasRegulatoryActs < ActiveRecord::Migration
  def change
    create_table "compras_regulatory_acts" do |t|
      t.string   "act_number"
      t.integer  "regulatory_act_type_id"
      t.date     "creation_date"
      t.date     "publication_date"
      t.date     "vigor_date"
      t.date     "end_date"
      t.text     "content"
      t.decimal  "budget_law_percent",           :precision => 10, :scale => 2, :default => 0.0
      t.decimal  "revenue_antecipation_percent", :precision => 10, :scale => 2, :default => 0.0
      t.decimal  "authorized_debt_value",        :precision => 10, :scale => 2, :default => 0.0
      t.datetime "created_at",                                                                   :null => false
      t.datetime "updated_at",                                                                   :null => false
      t.integer  "legal_text_nature_id"
    end

    add_index "compras_regulatory_acts", ["legal_text_nature_id"], :name => "cra_legal_text_nature_id"
    add_index "compras_regulatory_acts", ["regulatory_act_type_id"], :name => "cra_regulatory_act_type_id"
  end
end
