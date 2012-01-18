class AddNotaryIdToPropertyTransfers < ActiveRecord::Migration
  def change
    add_column :property_transfers, :notary_id, :integer
    add_index :property_transfers, :notary_id
    add_foreign_key :property_transfers, :notaries
  end
end
