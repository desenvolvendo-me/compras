class AddPurchaseDocumentToComprasBidderDocuments < ActiveRecord::Migration
  def change
    add_column :compras_bidder_documents, :purchase_document, :boolean, default: false

    execute <<-SQL
      UPDATE compras_bidder_documents
      SET purchase_document = true
    SQL
  end
end
