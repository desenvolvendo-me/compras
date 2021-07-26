class CreateTableComprasRegulatoryActTypeClassifications < ActiveRecord::Migration
  def change
    create_table "compras_regulatory_act_type_classifications" do |t|
      t.string   "description"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
