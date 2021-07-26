class AddUnicoCreditorToPriceCollectionProposal < ActiveRecord::Migration
  def change
    add_column :compras_price_collection_proposals, :creditor_id, :integer

    add_index :compras_price_collection_proposals, :creditor_id
    add_foreign_key :compras_price_collection_proposals, :unico_creditors, column: :creditor_id
  end
end
