class CreateProcessResponsibles < ActiveRecord::Migration
  def change
    create_table :compras_process_responsibles do |t|
      t.references :licitation_process
      t.references :stage_process
      t.references :employee

      t.timestamps
    end
    add_index :compras_process_responsibles, :licitation_process_id
    add_index :compras_process_responsibles, :stage_process_id
    add_index :compras_process_responsibles, :employee_id

    add_foreign_key :compras_process_responsibles, :compras_licitation_processes,
                    :column => :licitation_process_id
    add_foreign_key :compras_process_responsibles, :compras_stage_processes,
                    :column => :stage_process_id
    add_foreign_key :compras_process_responsibles, :compras_employees,
                    :column => :employee_id
  end
end
