class RemoveCreditorDocuments < ActiveRecord::Migration
  def change
    drop_table :compras_creditor_documents
  end
end
