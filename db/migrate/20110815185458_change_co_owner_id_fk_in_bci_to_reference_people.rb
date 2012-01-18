class ChangeCoOwnerIdFkInBciToReferencePeople < ActiveRecord::Migration
  def up
    remove_foreign_key :properties, :column => :co_owner_id
    add_foreign_key :properties, :people, :column => :co_owner_id
  end

  def down
    remove_foreign_key :properties, :column => :co_owner_id
    add_foreign_key :properties, :individuals, :column => :co_owner_id
  end
end
