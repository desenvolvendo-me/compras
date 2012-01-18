class CreateDocumentsFiscalProgrammings < ActiveRecord::Migration
  def change
    create_table :documents_fiscal_programmings, :id => false do |t|
      t.integer :document_id
      t.integer :fiscal_programming_id
    end

    add_index :documents_fiscal_programmings, :document_id
    add_index :documents_fiscal_programmings, :fiscal_programming_id
    add_foreign_key :documents_fiscal_programmings, :documents
    add_foreign_key :documents_fiscal_programmings, :fiscal_programmings
  end
end
