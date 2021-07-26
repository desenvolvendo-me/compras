class CreateTableComprasLicitationNotices < ActiveRecord::Migration
  def change
    create_table "compras_licitation_notices" do |t|
      t.integer  "licitation_process_id"
      t.integer  "number"
      t.date     "date"
      t.text     "observations"
      t.datetime "created_at",            :null => false
      t.datetime "updated_at",            :null => false
    end

    add_index "compras_licitation_notices", ["licitation_process_id"], :name => "cln_licitation_process_id"
  end
end
