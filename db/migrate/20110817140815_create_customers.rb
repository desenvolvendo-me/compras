class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :domain
      t.string :database

      t.timestamps
    end

    add_index :customers, :domain, :unique => true
  end
end
