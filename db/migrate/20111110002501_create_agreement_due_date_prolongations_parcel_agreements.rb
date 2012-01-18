class CreateAgreementDueDateProlongationsParcelAgreements < ActiveRecord::Migration
  def change
    create_table :agreement_due_date_prolongations_parcel_agreements, :id => false do |t|
      t.references :agreement_due_date_prolongation
      t.references :parcel_agreement
    end

    add_index :agreement_due_date_prolongations_parcel_agreements, [:agreement_due_date_prolongation_id, :parcel_agreement_id], :unique => true, :name => 'index_agreement_due_date_prolongation_id_parcel_agreement_id'

    add_foreign_key :agreement_due_date_prolongations_parcel_agreements, :agreement_due_date_prolongations, :name => 'fk_agreement_due_date_prolongation_id'
    add_foreign_key :agreement_due_date_prolongations_parcel_agreements, :parcel_agreements, :name => 'fk_parcel_agreement_id'
  end
end
