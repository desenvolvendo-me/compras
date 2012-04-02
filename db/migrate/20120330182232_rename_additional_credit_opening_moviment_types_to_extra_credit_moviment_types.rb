class RenameAdditionalCreditOpeningMovimentTypesToExtraCreditMovimentTypes < ActiveRecord::Migration
  def change
    rename_table :additional_credit_opening_moviment_types, :extra_credit_moviment_types
  end
end
