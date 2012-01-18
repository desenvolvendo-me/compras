class CreatePeriodicities < ActiveRecord::Migration
  def change
    create_table :periodicities do |t|
      t.string :name
      t.integer :period_in_days

      t.timestamps
    end
  end
end
