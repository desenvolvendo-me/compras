class RenameLicitationProcessInvitedBiddersToLicitationProcessBidders < ActiveRecord::Migration
  def up
    rename_table :licitation_process_invited_bidders, :licitation_process_bidders
    rename_table :licitation_process_invited_bidder_documents, :licitation_process_bidder_documents

    rename_column :licitation_process_bidder_documents, :licitation_process_invited_bidder_id, :licitation_process_bidder_id

    rename_index :licitation_process_bidder_documents, :lpivd_document_type_id, :lpvd_document_type_id
    rename_index :licitation_process_bidder_documents, :lpivd_licitation_process_invited_bidder_id, :lpvd_licitation_process_bidder_id
    rename_index :licitation_process_bidders, :lpib_licitation_process_id, :lpb_licitation_process_id
    rename_index :licitation_process_bidders, :lpib_provider_id, :lpb_provider_id

    remove_foreign_key :licitation_process_bidder_documents, :name => :lpivd_document_type_fk
    remove_foreign_key :licitation_process_bidder_documents, :name => :lpivd_licitation_process_invited_bidder_fk
    add_foreign_key :licitation_process_bidder_documents, :document_types, :name => :lpvd_document_type_fk
    add_foreign_key :licitation_process_bidder_documents, :licitation_process_bidders, :name => :lpvd_licitation_process_bidder_fk

    remove_foreign_key :licitation_process_bidders, :name => :lpib_licitation_process_fk
    remove_foreign_key :licitation_process_bidders, :name => :lpib_provider_fk
    add_foreign_key :licitation_process_bidders, :licitation_processes, :name => :lpb_licitation_process_fk
    add_foreign_key :licitation_process_bidders, :providers, :name => :lpb_provider_fk
  end
end
