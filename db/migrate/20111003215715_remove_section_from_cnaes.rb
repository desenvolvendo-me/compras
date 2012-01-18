class RemoveSectionFromCnaes < ActiveRecord::Migration
  def up
    remove_column :cnaes, :section
  end

  def down
    add_column :cnaes, :section, :string
  end
end
