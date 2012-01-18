class RenameLevelInCnaes < ActiveRecord::Migration
  def up
    rename_column :cnaes, :level, :chain_level
  end

  def down
    rename_column :cnaes, :chain_level, :level
  end
end
