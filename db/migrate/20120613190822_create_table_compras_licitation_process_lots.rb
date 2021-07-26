class CreateTableComprasLicitationProcessLots < ActiveRecord::Migration
  def change
    create_table "compras_licitation_process_lots" do |t|
      t.integer  "licitation_process_id"
      t.text     "observations"
      t.datetime "created_at",            :null => false
      t.datetime "updated_at",            :null => false
    end

    add_index "compras_licitation_process_lots", ["licitation_process_id"], :name => "clpl_licitation_process_id"
  end
end
