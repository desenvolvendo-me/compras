class CreateFiscalExecutions < ActiveRecord::Migration
  def change
    create_table :fiscal_executions do |t|
      t.references :person
      t.string :status
      t.references :juridic_action_type
      t.references :legal_case_place
      t.references :judicial_district
      t.references :judicial_court
      t.references :judicial_class_process
      t.references :lawyer
      t.string :forum_process_number
      t.string :execution_process_number
      t.string :embargo_process_number
      t.date :process_date
      t.date :execution_date
      t.string :protocol_number
      t.decimal :cause_value,  :precision => 10, :scale => 2
      t.decimal :honorary_percent, :precision => 10, :scale => 2
      t.decimal :justice_official_value, :precision => 10, :scale => 2
      t.integer :visit_number

      t.timestamps
    end
    add_index :fiscal_executions, :person_id
    add_index :fiscal_executions, :juridic_action_type_id
    add_index :fiscal_executions, :legal_case_place_id
    add_index :fiscal_executions, :judicial_district_id
    add_index :fiscal_executions, :judicial_court_id
    add_index :fiscal_executions, :judicial_class_process_id
    add_index :fiscal_executions, :lawyer_id

    add_foreign_key :fiscal_executions, :people
    add_foreign_key :fiscal_executions, :juridic_action_types
    add_foreign_key :fiscal_executions, :legal_case_places
    add_foreign_key :fiscal_executions, :judicial_districts
    add_foreign_key :fiscal_executions, :judicial_courts
    add_foreign_key :fiscal_executions, :judicial_class_processes
    add_foreign_key :fiscal_executions, :lawyers
  end
end
