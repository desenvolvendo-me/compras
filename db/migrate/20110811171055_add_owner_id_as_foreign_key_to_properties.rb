class AddOwnerIdAsForeignKeyToProperties < ActiveRecord::Migration
  def change
    add_foreign_key :properties, :people, :column => :owner_id
  end
end
