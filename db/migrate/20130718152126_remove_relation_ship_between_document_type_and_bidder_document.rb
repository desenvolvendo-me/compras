class RemoveRelationShipBetweenDocumentTypeAndBidderDocument < ActiveRecord::Migration
  def change
    remove_column :compras_bidder_documents, :document_type_id
  end
end
