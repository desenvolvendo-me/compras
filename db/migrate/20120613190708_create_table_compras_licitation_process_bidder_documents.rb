class CreateTableComprasLicitationProcessBidderDocuments < ActiveRecord::Migration
  def change
    create_table "compras_licitation_process_bidder_documents" do |t|
      t.integer  "licitation_process_bidder_id"
      t.integer  "document_type_id"
      t.string   "document_number"
      t.date     "emission_date"
      t.date     "validity"
      t.datetime "created_at",                   :null => false
      t.datetime "updated_at",                   :null => false
    end

    add_index "compras_licitation_process_bidder_documents", ["document_type_id"], :name => "clpbd_document_type_id"
    add_index "compras_licitation_process_bidder_documents", ["licitation_process_bidder_id"], :name => "clpbd_licitation_process_bidder_id"
  end
end
