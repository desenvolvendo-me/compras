class CreateCharacteristicTypes < ActiveRecord::Migration
  def change
    create_table :characteristic_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
