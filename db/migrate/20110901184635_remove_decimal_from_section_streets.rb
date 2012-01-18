class RemoveDecimalFromSectionStreets < ActiveRecord::Migration
  def up
    remove_column :section_streets, :decimal
  end

  def down
    add_column :section_streets, :decimal, :decimal, :precision => 5, :scale => 2
  end
end
