class CreateTableComprasJudgmentCommissionAdviceMembers < ActiveRecord::Migration
  def change
    create_table "compras_judgment_commission_advice_members" do |t|
      t.integer  "judgment_commission_advice_id"
      t.integer  "individual_id"
      t.string   "role"
      t.string   "role_nature"
      t.string   "registration"
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
      t.integer  "licitation_commission_member_id"
    end

    add_index "compras_judgment_commission_advice_members", ["individual_id"], :name => "cjcam_individual_id"
    add_index "compras_judgment_commission_advice_members", ["judgment_commission_advice_id"], :name => "cjcam_judgment_commission_advice_id"
    add_index "compras_judgment_commission_advice_members", ["licitation_commission_member_id"], :name => "cjcam_licitation_commission_member_id"
  end
end
