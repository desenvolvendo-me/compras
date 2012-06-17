class CreateAdministrativeProcessLiberation < ActiveRecord::Migration
  def change
    create_table :compras_administrative_process_liberations do |t|
      t.references :administrative_process
      t.references :employee
      t.date :date
    end

    add_index :compras_administrative_process_liberations, :administrative_process_id, :name => :capl_administrative_process_idx
    add_index :compras_administrative_process_liberations, :employee_id

    add_foreign_key :compras_administrative_process_liberations, :compras_administrative_processes, :column => :administrative_process_id, :name => :capl_administrative_process_fk
    add_foreign_key :compras_administrative_process_liberations, :compras_employees, :column => :employee_id
  end
end
