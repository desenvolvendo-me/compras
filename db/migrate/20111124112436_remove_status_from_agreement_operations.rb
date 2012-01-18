class RemoveStatusFromAgreementOperations < ActiveRecord::Migration
  def change
    remove_column :agreement_operations, :status
  end
end
