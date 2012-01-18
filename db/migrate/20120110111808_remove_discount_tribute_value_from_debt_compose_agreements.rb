class RemoveDiscountTributeValueFromDebtComposeAgreements < ActiveRecord::Migration
  def change
    remove_column :debt_compose_agreements, :discount_tribute_value
  end
end
