class DropAgreementOperationsRevenues < ActiveRecord::Migration
  def change
    drop_table :agreement_operations_revenues
  end
end
