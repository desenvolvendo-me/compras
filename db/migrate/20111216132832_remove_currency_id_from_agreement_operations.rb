class RemoveCurrencyIdFromAgreementOperations < ActiveRecord::Migration
  def change
    remove_column :agreement_operations, :currency_id
  end
end
