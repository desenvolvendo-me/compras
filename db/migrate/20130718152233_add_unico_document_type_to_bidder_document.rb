class AddUnicoDocumentTypeToBidderDocument < ActiveRecord::Migration
  def change
    add_column :compras_bidder_documents, :document_type_id, :integer

    add_index :compras_bidder_documents, :document_type_id
    add_foreign_key :compras_bidder_documents, :unico_document_types, column: :document_type_id
  end
end
