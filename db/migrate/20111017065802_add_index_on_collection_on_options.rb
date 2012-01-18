class AddIndexOnCollectionOnOptions < ActiveRecord::Migration
  def change
    add_index :options, [:collection_id, :collection_type]
  end
end
