class AddCodeToStates < ActiveRecord::Migration
  def change
    add_column :states, :code, :integer
  end
end
