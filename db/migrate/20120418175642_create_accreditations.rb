class CreateAccreditations < ActiveRecord::Migration
  def change
    create_table :accreditations do |t|
      t.references :licitation_process
      t.references :licitation_commission

      t.timestamps
    end

    add_index :accreditations, :licitation_process_id
    add_index :accreditations, :licitation_commission_id
    add_foreign_key :accreditations, :licitation_processes
    add_foreign_key :accreditations, :licitation_commissions
  end
end
