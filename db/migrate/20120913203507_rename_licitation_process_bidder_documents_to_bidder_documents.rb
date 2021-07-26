class RenameLicitationProcessBidderDocumentsToBidderDocuments < ActiveRecord::Migration
  def change
    rename_table :compras_licitation_process_bidder_documents,
                 :compras_bidder_documents

    rename_column :compras_bidder_documents, :licitation_process_bidder_id,
                  :bidder_id
  end
end
