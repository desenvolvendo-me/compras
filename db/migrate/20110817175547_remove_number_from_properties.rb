class RemoveNumberFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :number
  end

  def down
    add_column :properties, :number, :string
  end
end
