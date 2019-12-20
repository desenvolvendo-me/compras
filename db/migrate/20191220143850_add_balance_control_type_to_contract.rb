class AddBalanceControlTypeToContract < ActiveRecord::Migration
  def change
    add_column :compras_contracts,
               :balance_control_type, :string
    end
end
