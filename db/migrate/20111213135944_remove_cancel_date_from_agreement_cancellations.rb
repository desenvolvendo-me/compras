class RemoveCancelDateFromAgreementCancellations < ActiveRecord::Migration
  def change
    remove_column :agreement_cancellations, :cancel_date
  end
end
