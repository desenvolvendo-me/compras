class CreateLicitationProcessInvitedBidderDocuments < ActiveRecord::Migration
  def change
    create_table :licitation_process_invited_bidder_documents do |t|
      t.references :licitation_process_invited_bidder
      t.references :document_type
      t.string :document_number
      t.date :emission_date
      t.date :validity

      t.timestamps
    end

    add_index :licitation_process_invited_bidder_documents, :licitation_process_invited_bidder_id, :name => 'lpivd_licitation_process_invited_bidder_id'
    add_index :licitation_process_invited_bidder_documents, :document_type_id, :name => 'lpivd_document_type_id'
    add_foreign_key :licitation_process_invited_bidder_documents, :licitation_process_invited_bidders, :name => 'lpivd_licitation_process_invited_bidder_fk'
    add_foreign_key :licitation_process_invited_bidder_documents, :document_types, :name => 'lpivd_document_type_fk'
  end
end
