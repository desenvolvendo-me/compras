class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :unit
      t.integer :amount

      t.timestamps
    end
  end
end
