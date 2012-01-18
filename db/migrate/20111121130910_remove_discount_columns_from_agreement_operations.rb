class RemoveDiscountColumnsFromAgreementOperations < ActiveRecord::Migration
  def change
    remove_column :agreement_operations, :discount_tribute_value
    remove_column :agreement_operations, :discount_correction_value
    remove_column :agreement_operations, :discount_interest_value
    remove_column :agreement_operations, :discount_fine_value
  end
end
