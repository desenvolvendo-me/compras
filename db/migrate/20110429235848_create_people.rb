class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :mother
      t.string :father
      t.date :birthdate
      t.integer :gender

      t.timestamps
    end
  end
end
