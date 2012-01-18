class CreateFiscalExecutionDocuments < ActiveRecord::Migration
  def change
    create_table :fiscal_execution_documents do |t|
      t.references :fiscal_execution
      t.references :judicial_document_type
      t.string :sequence_generator
      t.date :document_date
      t.date :withdraw_date
      t.date :judicial_permit_date
      t.decimal :withdraw_value
      t.text :history
      t.string :document_number

      t.timestamps
    end
    add_index :fiscal_execution_documents, :fiscal_execution_id
    add_index :fiscal_execution_documents, :judicial_document_type_id

    add_foreign_key :fiscal_execution_documents, :fiscal_executions
    add_foreign_key :fiscal_execution_documents, :judicial_document_types
  end
end
