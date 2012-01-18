class RemoveComplementFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :complement
  end

  def down
    add_column :properties, :complement, :string
  end
end
