class RemoveMoneyColumnsFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :initial_amount_payable
    remove_column :agreements, :discount_amount_payable
    remove_column :agreements, :final_amount_payable
    remove_column :agreements, :initial_fine
    remove_column :agreements, :discount_fine
    remove_column :agreements, :final_fine
    remove_column :agreements, :initial_interest
    remove_column :agreements, :discount_interest
    remove_column :agreements, :final_interest
    remove_column :agreements, :initial_correction
    remove_column :agreements, :discount_correction
    remove_column :agreements, :final_correction
  end
end
