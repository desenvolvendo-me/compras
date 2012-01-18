class RemoveChainLevelFromCnaes < ActiveRecord::Migration
  def change
    remove_column :cnaes, :chain_level
  end
end
