class CreateFiscalActionsOfficialDocuments < ActiveRecord::Migration
  def change
    create_table :fiscal_actions_official_documents, :id => false do |t|
      t.integer :fiscal_action_id
      t.integer :official_document_id
    end
    add_index :fiscal_actions_official_documents, :fiscal_action_id
    add_index :fiscal_actions_official_documents, :official_document_id
    add_foreign_key :fiscal_actions_official_documents, :fiscal_actions, :name => :faod_fiscal_actions_fk
    add_foreign_key :fiscal_actions_official_documents, :official_documents, :name => :faod_official_documents_fk
  end
end
