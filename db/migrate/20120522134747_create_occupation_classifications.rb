class CreateOccupationClassifications < ActiveRecord::Migration
  def up
    create_table :occupation_classifications do |t|
      t.string  :code, :null => false
      t.string  :name, :null => false
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
    add_index :occupation_classifications, :code, :unique => true
    add_index :occupation_classifications, :parent_id
  end

  def down
    drop_table :occupation_classifications
  end
end
