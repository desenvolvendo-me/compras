class CreateTableComprasPledgeHistorics < ActiveRecord::Migration
  def change
    create_table "compras_pledge_historics" do |t|
      t.string   "description"
      t.integer  "entity_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
      t.integer  "year"
      t.string   "source"
    end

    add_index "compras_pledge_historics", ["entity_id"], :name => "cph_entity_id"
  end
end
