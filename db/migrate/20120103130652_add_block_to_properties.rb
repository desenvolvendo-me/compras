class AddBlockToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :block, :string
  end
end
