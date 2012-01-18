class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :acronym
      t.boolean :current

      t.timestamps
    end
  end
end
