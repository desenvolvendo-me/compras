class CreateTableComprasDisseminationSources < ActiveRecord::Migration
  def change
    create_table "compras_dissemination_sources" do |t|
      t.integer  "communication_source_id"
      t.string   "description"
      t.datetime "created_at",              :null => false
      t.datetime "updated_at",              :null => false
    end

    add_index "compras_dissemination_sources", ["communication_source_id"], :name => "cds_communication_source_id"
  end
end
