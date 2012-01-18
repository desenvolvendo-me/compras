class RemoveDefaultFromStates < ActiveRecord::Migration
  def change
    remove_column :states, :default
  end
end
