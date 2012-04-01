class ChangeAdditionalCreditOpeningMovimentTypeValueToDecimal < ActiveRecord::Migration
  def up
    change_column :additional_credit_opening_moviment_types, :value, :decimal
  end
end
