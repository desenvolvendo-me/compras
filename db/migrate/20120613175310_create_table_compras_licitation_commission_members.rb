class CreateTableComprasLicitationCommissionMembers < ActiveRecord::Migration
  def change
    create_table "compras_licitation_commission_members" do |t|
      t.integer  "licitation_commission_id"
      t.integer  "individual_id"
      t.string   "role"
      t.string   "role_nature"
      t.string   "registration"
      t.datetime "created_at",               :null => false
      t.datetime "updated_at",               :null => false
    end

    add_index "compras_licitation_commission_members", ["individual_id"], :name => "clcm_individual_id"
    add_index "compras_licitation_commission_members", ["licitation_commission_id"], :name => "clcm_licitation_commission_id"
  end
end
