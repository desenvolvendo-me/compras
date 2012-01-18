class ChangePersonIdFkToReferencePeople < ActiveRecord::Migration
  def up
    remove_foreign_key :accountants, :column => :person_id
    add_foreign_key :accountants, :people
  end

  def down
    remove_foreign_key :accountants, :people
    add_foreign_key :accountants, :individuals, :column => :person_id
  end
end
