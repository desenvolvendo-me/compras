class CreateAgreementCancellations < ActiveRecord::Migration
  def change
    create_table :agreement_cancellations do |t|
      t.string :agreement_ids
      t.string :person_ids
      t.date :date_agreement
      t.string :setting_ids
      t.references :motive
      t.date :cancel_date
      t.string :comment

      t.timestamps
    end
    add_index :agreement_cancellations, :motive_id
    add_foreign_key :agreement_cancellations, :motives
  end
end
