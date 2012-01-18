class UseCompositedIndexForAddressableOnAddresses < ActiveRecord::Migration
  def up
    remove_index :addresses, :addressable_id

    add_index :addresses, [:addressable_id, :addressable_type]
  end

  def down
    remove_index :addresses, [:addressable_id, :addressable_type]

    add_index :addresses, :addressable_id
  end
end
