class RemovePurchaseSolicitationIdFromPurchaseSolicitationItem < ActiveRecord::Migration
  def up
    remove_column :compras_purchase_form_items, :purchase_solicitation_id
  end

  def down
    add_column :compras_purchase_form_items, :purchase_solicitation_id,
               :integer

    add_index :compras_purchase_form_items, :purchase_solicitation_id
    add_foreign_key :compras_purchase_form_items, :compras_purchase_solicitations,
                    column: :purchase_solicitation_id
  end
end
