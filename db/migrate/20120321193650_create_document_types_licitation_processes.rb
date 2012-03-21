class CreateDocumentTypesLicitationProcesses < ActiveRecord::Migration
  def change
    create_table :document_types_licitation_processes, :id => false do |t|
      t.integer :document_type_id
      t.integer :licitation_process_id
    end

    add_index :document_types_licitation_processes, :document_type_id, :name => 'dtlp_document_type_id'
    add_index :document_types_licitation_processes, :licitation_process_id, :name => 'dtlp_licitation_process_id'

    add_foreign_key :document_types_licitation_processes, :document_types, :name => 'dtlp_document_types_fk'
    add_foreign_key :document_types_licitation_processes, :licitation_processes, :name => 'dtlp_licitation_processes_fk'
  end
end
