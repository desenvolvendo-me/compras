class CreateNotaries < ActiveRecord::Migration
  def change
    create_table :notaries do |t|
      t.string :name

      t.timestamps
    end
  end
end
