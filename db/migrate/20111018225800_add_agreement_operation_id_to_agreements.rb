class AddAgreementOperationIdToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :agreement_operation_id, :integer
    add_index  :agreements, :agreement_operation_id
    add_foreign_key :agreements, :agreement_operations
  end
end
