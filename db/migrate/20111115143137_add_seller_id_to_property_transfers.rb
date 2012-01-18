class AddSellerIdToPropertyTransfers < ActiveRecord::Migration
  def change
    add_column :property_transfers, :seller_id, :integer
    add_index :property_transfers, :seller_id
    add_foreign_key :property_transfers, :people, :column => :seller_id
  end
end
