class CreateTableComprasServiceOrContractTypes < ActiveRecord::Migration
  def change
    create_table "compras_service_or_contract_types" do |t|
      t.integer  "tce_code"
      t.text     "description"
      t.string   "service_goal"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end
  end
end
