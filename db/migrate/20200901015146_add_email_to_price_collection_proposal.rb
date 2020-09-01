class AddEmailToPriceCollectionProposal < ActiveRecord::Migration
  def change
    add_column :compras_price_collection_proposals, :email, :string
  end
end
