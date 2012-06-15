class CreateTableComprasLicitationCommissionResponsibles < ActiveRecord::Migration
  def change
    create_table "compras_licitation_commission_responsibles" do |t|
      t.integer  "licitation_commission_id"
      t.integer  "individual_id"
      t.string   "role"
      t.string   "class_register"
      t.datetime "created_at",               :null => false
      t.datetime "updated_at",               :null => false
    end

    add_index "compras_licitation_commission_responsibles", ["individual_id"], :name => "clcr_individual_id"
    add_index "compras_licitation_commission_responsibles", ["licitation_commission_id"], :name => "clcr_licitation_commission_id"
  end
end
