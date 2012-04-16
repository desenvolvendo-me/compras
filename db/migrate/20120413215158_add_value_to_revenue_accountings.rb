class AddValueToRevenueAccountings < ActiveRecord::Migration
  def change
    add_column :revenue_accountings, :value, :decimal, :precision => 10, :scale => 2
  end
end
