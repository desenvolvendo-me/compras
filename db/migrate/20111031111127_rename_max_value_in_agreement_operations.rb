class RenameMaxValueInAgreementOperations < ActiveRecord::Migration
  def change
    rename_column :agreement_operations, :max_value, :individual_max_value
  end
end
