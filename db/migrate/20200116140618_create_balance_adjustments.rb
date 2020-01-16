class CreateBalanceAdjustments < ActiveRecord::Migration
  def change
    create_table :compras_balance_adjustments do |t|
      t.references :licitation_process
      t.references :contract
      t.references :purchase_solicitation
      t.text :observation

      t.timestamps
    end
  end
end
