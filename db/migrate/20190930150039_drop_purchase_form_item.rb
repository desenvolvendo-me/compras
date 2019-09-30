class DropPurchaseFormItem < ActiveRecord::Migration
  def up
    drop_table :compras_purchase_form_items
  end

  def down
    create_table :compras_purchase_form_items do |t|
      t.references :purchase_solicitation
      t.references :purchase_form

      t.timestamps
    end

    add_index :compras_purchase_form_items, :purchase_solicitation_id
    add_foreign_key :compras_purchase_form_items,
                    :compras_purchase_solicitations,
                    column: :purchase_solicitation_id

    add_index :compras_purchase_form_items, :purchase_form_id
    add_foreign_key :compras_purchase_form_items,
                    :compras_purchase_forms,
                    column: :purchase_form_id
  end
end
