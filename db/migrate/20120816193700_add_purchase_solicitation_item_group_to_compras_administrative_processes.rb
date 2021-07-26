class AddPurchaseSolicitationItemGroupToComprasAdministrativeProcesses < ActiveRecord::Migration
  def change
    add_column :compras_administrative_processes, :purchase_solicitation_item_group_id, :integer

    add_index :compras_administrative_processes, :purchase_solicitation_item_group_id, :name => :ap_item_group_idx
    add_foreign_key :compras_administrative_processes, :compras_purchase_solicitation_item_groups,
                                                       :column => :purchase_solicitation_item_group_id,
                                                       :name => :ap_purchase_solicitation_item_group_fk
  end
end
