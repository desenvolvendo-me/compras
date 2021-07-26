class AddDescriptionOnPurchaseSolicitationItemGroups < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitation_item_groups, :description, :string

    execute <<-SQL
      UPDATE compras_purchase_solicitation_item_groups
      SET description = id
    SQL
  end
end
