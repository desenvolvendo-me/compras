class CreateLicitationProcessImpugnments < ActiveRecord::Migration
  def change
    create_table :licitation_process_impugnments do |t|
      t.references :licitation_process
      t.date :impugnment_date
      t.string :related
      t.references :person
      t.text :valid_reason
      t.string :situation, :default => 'Pendente'
      t.date :judgment_date
      t.text :observation

      t.timestamps
    end

    add_index :licitation_process_impugnments, :licitation_process_id
    add_index :licitation_process_impugnments, :person_id
    add_foreign_key :licitation_process_impugnments, :licitation_processes
    add_foreign_key :licitation_process_impugnments, :people
  end
end
