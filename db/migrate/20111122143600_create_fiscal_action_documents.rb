class CreateFiscalActionDocuments < ActiveRecord::Migration
  def change
    create_table :fiscal_action_documents do |t|
      t.string :situation
      t.date :delivery_date
      t.date :return_date
      t.string :observation
      t.references :fiscal_action
      t.references :document

      t.timestamps
    end
    
    add_index :fiscal_action_documents, :fiscal_action_id
    add_index :fiscal_action_documents, :document_id
    add_foreign_key :fiscal_action_documents, :fiscal_actions
    add_foreign_key :fiscal_action_documents, :documents
  end
end
