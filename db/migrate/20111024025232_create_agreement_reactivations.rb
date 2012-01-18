class CreateAgreementReactivations < ActiveRecord::Migration
  def change
    create_table :agreement_reactivations do |t|
      t.string :agreements_ids
      t.string :person_ids
      t.date :date_agreement
      t.date :cancel_date

      t.timestamps
    end
  end
end
