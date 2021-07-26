class CreateTableComprasLicitationProcessBidders < ActiveRecord::Migration
  def change
    create_table "compras_licitation_process_bidders" do |t|
      t.integer  "licitation_process_id"
      t.integer  "provider_id"
      t.string   "protocol"
      t.date     "protocol_date"
      t.date     "receipt_date"
      t.boolean  "invited",                                             :default => false
      t.datetime "created_at",                                                             :null => false
      t.datetime "updated_at",                                                             :null => false
      t.string   "status"
      t.decimal  "technical_score",       :precision => 5, :scale => 2
    end

    add_index "compras_licitation_process_bidders", ["licitation_process_id"], :name => "clpb_licitation_process_id"
    add_index "compras_licitation_process_bidders", ["provider_id"], :name => "clpb_provider_id"
  end
end
