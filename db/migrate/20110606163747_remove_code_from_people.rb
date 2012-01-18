class RemoveCodeFromPeople < ActiveRecord::Migration
  def change
    remove_column :people, :code
  end
end
