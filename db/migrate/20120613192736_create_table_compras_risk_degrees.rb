class CreateTableComprasRiskDegrees < ActiveRecord::Migration
  def change
    create_table "compras_risk_degrees" do |t|
      t.string   "name"
      t.string   "level"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
