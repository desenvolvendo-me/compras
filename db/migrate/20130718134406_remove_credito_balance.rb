class RemoveCreditoBalance < ActiveRecord::Migration
  def change
    drop_table :compras_creditor_balances
  end
end
