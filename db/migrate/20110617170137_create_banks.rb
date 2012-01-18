class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name
      t.integer :code
      t.string :acronym

      t.timestamps
    end
  end
end
