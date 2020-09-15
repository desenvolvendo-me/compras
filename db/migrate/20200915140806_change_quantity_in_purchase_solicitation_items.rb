class ChangeQuantityInPurchaseSolicitationItems < ActiveRecord::Migration
  def change
    rename_column :compras_purchase_solicitation_items, :quantity, :quantity_old
    add_column :compras_purchase_solicitation_items, :quantity, :integer

    execute <<-SQL
      with t as (
        select id, quantity_old::INTEGER
        from compras_purchase_solicitation_items
      )

      update compras_purchase_solicitation_items
      set quantity = t.quantity_old
      from t
      where compras_purchase_solicitation_items.id = t.id
    SQL
  end
1end
