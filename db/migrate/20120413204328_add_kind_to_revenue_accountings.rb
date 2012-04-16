class AddKindToRevenueAccountings < ActiveRecord::Migration
  def change
    add_column :revenue_accountings, :kind, :string
  end
end
