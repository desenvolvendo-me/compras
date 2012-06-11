class CreateUnicoStates < ActiveRecord::Migration
  def change
    rename_table :states, :unico_states
  end
end
