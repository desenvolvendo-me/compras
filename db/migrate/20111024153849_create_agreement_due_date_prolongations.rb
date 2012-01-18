class CreateAgreementDueDateProlongations < ActiveRecord::Migration
  def change
    create_table :agreement_due_date_prolongations do |t|
      t.references :agreement

      t.timestamps
    end
    add_index :agreement_due_date_prolongations, :agreement_id
    add_foreign_key :agreement_due_date_prolongations, :agreements
  end
end
