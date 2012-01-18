class AddGenderIdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :gender_id, :integer
    add_foreign_key :people, :genders
  end
end
