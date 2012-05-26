class AddParentForeignKeyToOccupationClassifications < ActiveRecord::Migration
  def change
    add_foreign_key :occupation_classifications, :occupation_classifications, :column => :parent_id
  end
end
