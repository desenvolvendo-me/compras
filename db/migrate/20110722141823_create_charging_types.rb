class CreateChargingTypes < ActiveRecord::Migration
  def change
    create_table :charging_types do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
