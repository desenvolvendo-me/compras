class CreatePurchaseSolicitationItemGroupPurchaseSolicitations < ActiveRecord::Migration
  def change
    create_table :compras_purchase_solicitation_item_group_purchase_solicitations do |t|
      t.references :purchase_solicitation_item_group
      t.references :purchase_solicitation

      t.timestamps
    end

    add_index :compras_purchase_solicitation_item_group_purchase_solicitations, :purchase_solicitation_item_group_id, :name => :cpsigps_purchase_solicitation_group_id
    add_index :compras_purchase_solicitation_item_group_purchase_solicitations, :purchase_solicitation_id, :name => :cpsigps_purchase_solicitation_id
    add_foreign_key :compras_purchase_solicitation_item_group_purchase_solicitations, :compras_purchase_solicitation_item_groups, :name => :cpsigps_purchase_solicitation_item_group_fk, :column => :purchase_solicitation_item_group_id
    add_foreign_key :compras_purchase_solicitation_item_group_purchase_solicitations, :compras_purchase_solicitations, :name => :cpsigps_purchase_solicitation_fk, :column => :purchase_solicitation_id
  end
end
