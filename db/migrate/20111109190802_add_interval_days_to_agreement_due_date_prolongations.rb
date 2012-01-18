class AddIntervalDaysToAgreementDueDateProlongations < ActiveRecord::Migration
  def change
    add_column :agreement_due_date_prolongations, :interval_days, :integer
  end
end
