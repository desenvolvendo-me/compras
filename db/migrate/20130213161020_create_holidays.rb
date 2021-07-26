class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :compras_holidays do |t|
      t.string :name, :require => true
      t.integer :year, :require => true
      t.integer :month, :require => true
      t.integer :day, :require => true
      t.boolean :recurrent, :default => false

      t.timestamps
    end
  end
end
