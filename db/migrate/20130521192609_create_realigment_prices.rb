class CreateRealigmentPrices < ActiveRecord::Migration
  def change
    create_table :compras_realigment_prices do |t|
      t.references :purchase_process_creditor_proposal
      t.references :purchase_process_item
      t.decimal :price, :precision => 10, :scale => 2
      t.string :brand
      t.date :delivery_date
      t.integer :quantity

      t.timestamps
    end

    add_index :compras_realigment_prices, :purchase_process_creditor_proposal_id, name: "crp_proposal_id"
    add_index :compras_realigment_prices, :purchase_process_item_id

    add_foreign_key :compras_realigment_prices, :compras_purchase_process_creditor_proposals,
                    column: :purchase_process_creditor_proposal_id, name: "crp_proposal_id_fk"
    add_foreign_key :compras_realigment_prices, :compras_purchase_process_items, column: :purchase_process_item_id
  end
end
