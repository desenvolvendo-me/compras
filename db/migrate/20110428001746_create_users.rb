class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.database_authenticatable

      t.timestamps
    end
  end
end
