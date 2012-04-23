class CreateJudgmentCommissionAdvices < ActiveRecord::Migration
  def change
    create_table :judgment_commission_advices do |t|
      t.references :licitation_process
      t.references :licitation_commission
      t.integer :minutes_number
      t.integer :year
      t.integer :judgment_sequence

      t.timestamps
    end

    add_index :judgment_commission_advices, :licitation_process_id
    add_index :judgment_commission_advices, :licitation_commission_id

    add_foreign_key :judgment_commission_advices, :licitation_processes
    add_foreign_key :judgment_commission_advices, :licitation_commissions

    add_index :judgment_commission_advices, [:minutes_number, :year], :unique => true
  end
end
