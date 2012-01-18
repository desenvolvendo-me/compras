class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :code
      t.string  :acronym
      t.string  :name

      t.timestamps
    end
  end
end
