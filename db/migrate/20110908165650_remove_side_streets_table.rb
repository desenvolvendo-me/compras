class RemoveSideStreetsTable < ActiveRecord::Migration
  def up
    drop_table :side_streets
  end

  def down
    create_table :side_streets do |t|
      t.string :name
      t.string :acronym
      t.timestamps
    end
  end
end