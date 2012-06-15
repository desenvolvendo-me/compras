class CreateTableComprasDocumentTypesComprasLicitationProcesses < ActiveRecord::Migration
  def change
    create_table "compras_document_types_compras_licitation_processes", :id => false do |t|
      t.integer "document_type_id"
      t.integer "licitation_process_id"
    end

    add_index "compras_document_types_compras_licitation_processes", ["document_type_id"], :name => "cdtclp_document_type_id"
    add_index "compras_document_types_compras_licitation_processes", ["licitation_process_id"], :name => "cdtclp_licitation_process_id"
  end
end
