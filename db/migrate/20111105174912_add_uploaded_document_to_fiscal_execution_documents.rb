class AddUploadedDocumentToFiscalExecutionDocuments < ActiveRecord::Migration
  def change
    add_column :fiscal_execution_documents, :uploaded_document, :string
  end
end
