class RenamePeriodFromComprasDirectPurchases < ActiveRecord::Migration
  def change
    rename_column :compras_direct_purchases, :period, :delivery_term
    rename_column :compras_direct_purchases, :period_unit, :delivery_term_period
  end
end
