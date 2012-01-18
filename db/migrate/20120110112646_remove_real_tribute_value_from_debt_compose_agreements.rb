class RemoveRealTributeValueFromDebtComposeAgreements < ActiveRecord::Migration
  def change
    remove_column :debt_compose_agreements, :real_tribute_value
  end
end
