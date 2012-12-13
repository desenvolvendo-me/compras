class AddDisabledToBidders < ActiveRecord::Migration
  def change
    add_column :compras_bidders, :disabled, :boolean, :default => false
    add_column :compras_bidders, :disabled_at, :datetime
  end
end
