class AddCollectionTypeAndCollectionIdToOptions < ActiveRecord::Migration
  def change
    add_column :options, :collection_type, :string
    add_column :options, :collection_id, :integer
  end
end
