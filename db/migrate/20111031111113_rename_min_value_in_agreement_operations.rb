class RenameMinValueInAgreementOperations < ActiveRecord::Migration
  def change
    rename_column :agreement_operations, :min_value, :individual_min_value
  end
end
