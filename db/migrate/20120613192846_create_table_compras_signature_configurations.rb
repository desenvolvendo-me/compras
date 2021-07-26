class CreateTableComprasSignatureConfigurations < ActiveRecord::Migration
  def change
    create_table "compras_signature_configurations" do |t|
      t.string   "report"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
