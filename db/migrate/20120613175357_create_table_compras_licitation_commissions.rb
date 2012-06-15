class CreateTableComprasLicitationCommissions < ActiveRecord::Migration
  def change
    create_table "compras_licitation_commissions" do |t|
      t.string   "commission_type"
      t.date     "nomination_date"
      t.date     "expiration_date"
      t.date     "exoneration_date"
      t.text     "description"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
      t.integer  "regulatory_act_id"
    end

    add_index "compras_licitation_commissions", ["regulatory_act_id"], :name => "clc_regulatory_act_id"
  end
end
