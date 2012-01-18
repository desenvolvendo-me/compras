class RemoveMinAndMaxValuesFromAgreementOperations < ActiveRecord::Migration
  def change
    remove_column :agreement_operations, :individual_min_value
    remove_column :agreement_operations, :individual_max_value
    remove_column :agreement_operations, :company_min_value
    remove_column :agreement_operations, :company_max_value
  end
end
