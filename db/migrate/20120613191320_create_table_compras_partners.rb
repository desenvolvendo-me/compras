class CreateTableComprasPartners < ActiveRecord::Migration
  def change
    create_table "compras_partners" do |t|
      t.integer  "person_id"
      t.decimal  "percentage", :precision => 10, :scale => 2
      t.datetime "created_at",                                :null => false
      t.datetime "updated_at",                                :null => false
      t.integer  "company_id"
    end

    add_index "compras_partners", ["company_id"], :name => "cp_company_id"
    add_index "compras_partners", ["person_id"], :name => "cp_person_id"
  end
end
