class CreateTableComprasProviderLicitationDocuments < ActiveRecord::Migration
  def change
    create_table "compras_provider_licitation_documents" do |t|
      t.integer "provider_id"
      t.integer "document_type_id"
      t.string  "document_number"
      t.date    "emission_date"
      t.date    "expiration_date"
    end

    add_index "compras_provider_licitation_documents", ["document_type_id"], :name => "cpld_document_type_id"
    add_index "compras_provider_licitation_documents", ["provider_id"], :name => "cpld_provider_id"
  end
end
