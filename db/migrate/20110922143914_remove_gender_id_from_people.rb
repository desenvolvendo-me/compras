class RemoveGenderIdFromPeople < ActiveRecord::Migration
  def up
    remove_column :people, :gender_id
  end

  def down
    add_column :people, :gender_id, :integer
    add_index :people, :gender_id
    add_foreign_key :people, :genders
  end
end
