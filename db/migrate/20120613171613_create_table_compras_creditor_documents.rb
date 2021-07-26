class CreateTableComprasCreditorDocuments < ActiveRecord::Migration
  def change
    create_table "compras_creditor_documents" do |t|
      t.integer  "creditor_id"
      t.integer  "document_type_id"
      t.string   "document_number"
      t.date     "emission_date"
      t.date     "validity"
      t.string   "issuer"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
    end

    add_index "compras_creditor_documents", ["creditor_id"], :name => "ccd_creditor_id"
    add_index "compras_creditor_documents", ["document_type_id"], :name => "ccd_document_type_id"
  end
end
