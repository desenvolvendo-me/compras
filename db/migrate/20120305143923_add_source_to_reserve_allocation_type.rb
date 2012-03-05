class AddSourceToReserveAllocationType < ActiveRecord::Migration
  def change
    add_column :reserve_allocation_types, :source, :string
  end
end
