class RemoveDueDateFromAgreementOperations < ActiveRecord::Migration
  def change
    remove_column :agreement_operations, :due_date
  end
end
