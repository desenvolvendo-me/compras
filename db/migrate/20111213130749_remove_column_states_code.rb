class RemoveColumnStatesCode < ActiveRecord::Migration
  def change
    remove_column :states, :code
  end
end
