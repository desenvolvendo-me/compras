class RemovePurchaseFormIdFromPurchaseSolicitation < ActiveRecord::Migration

  def up
    remove_column :compras_purchase_solicitations,
                  :purchase_form_id
  end

  def down
    add_column :compras_purchase_solicitations,
               :purchase_form_id, :integer

    add_index :compras_purchase_solicitations, :purchase_form_id
    add_foreign_key :compras_purchase_solicitations,
                    :compras_purchase_forms, column: :purchase_form_id
  end

end
