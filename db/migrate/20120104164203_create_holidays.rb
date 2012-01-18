class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :name
      t.integer :year
      t.integer :month    , :required => true
      t.integer :day      , :required => true
      t.boolean :recurrent, :default => false

      t.timestamps
    end
  end
end
