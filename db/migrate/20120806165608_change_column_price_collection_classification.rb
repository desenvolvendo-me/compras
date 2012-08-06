class ChangeColumnPriceCollectionClassification < ActiveRecord::Migration
  def change
    remove_column :compras_price_collection_classifications, :creditor_id

    add_column :compras_price_collection_classifications, :price_collection_proposal_id, :integer

    add_index :compras_price_collection_classifications, :price_collection_proposal_id, :name => :cpcc_pcp_id

    add_foreign_key :compras_price_collection_classifications, :compras_price_collection_proposals,
                    :column => :price_collection_proposal_id, :name => :cpcc_cpcp_id_fk
  end
end
