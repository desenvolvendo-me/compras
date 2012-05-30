class CreateCreditorDocuments < ActiveRecord::Migration
  def change
    create_table :creditor_documents do |t|
      t.references :creditor
      t.references :document_type
      t.string :document_number
      t.date :emission_date
      t.date :validity
      t.string :issuer

      t.timestamps
    end

    add_index :creditor_documents, :creditor_id
    add_index :creditor_documents, :document_type_id
    add_foreign_key :creditor_documents, :creditors
    add_foreign_key :creditor_documents, :document_types
  end
end
