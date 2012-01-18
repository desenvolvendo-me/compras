class CreateFieldCalculations < ActiveRecord::Migration
  def change
    create_table :field_calculations do |t|
      t.string :name
      t.string :table

      t.timestamps
    end
  end
end
