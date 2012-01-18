class ChangeOwnerIdFkInBciToReferencePeople < ActiveRecord::Migration
  def up
    remove_foreign_key :properties, :column => :owner_id
    add_foreign_key :properties, :people, :column => :owner_id
  end

  def down
    remove_foreign_key :properties, :column => :owner_id
    add_foreign_key :properties, :individuals, :column => :owner_id
  end
end
