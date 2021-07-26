class RemoveCreditoSecondaryCnae < ActiveRecord::Migration
  def change
    drop_table :compras_creditor_secondary_cnaes
  end
end
