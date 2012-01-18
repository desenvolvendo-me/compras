class CreateFiscalVerifications < ActiveRecord::Migration
  def change
    create_table :fiscal_verifications do |t|
      t.date :base_date
      t.string :situation
      t.references :fiscal_action
      t.date :start_at
      t.date :finished_at
      t.integer :days_for_payment
      t.string :penalty_for_breach

      t.timestamps
    end
    add_index :fiscal_verifications, :fiscal_action_id
    add_foreign_key :fiscal_verifications, :fiscal_actions
  end
end
