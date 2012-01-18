class RemoveDecimalFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :decimal
  end

  def down
    add_column :properties, :decimal, :string
  end
end
