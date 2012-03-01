class CreateProviderLicitationDocuments < ActiveRecord::Migration
  def change
    create_table :provider_licitation_documents do |t|
      t.references :provider
      t.references :document_type
      t.string :document_number
      t.date :emission_date
      t.date :expiration_date
    end

    add_index :provider_licitation_documents, :provider_id
    add_index :provider_licitation_documents, :document_type_id
    add_foreign_key :provider_licitation_documents, :providers
    add_foreign_key :provider_licitation_documents, :document_types
  end
end
