class RemoveActiveFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :active
  end
end
