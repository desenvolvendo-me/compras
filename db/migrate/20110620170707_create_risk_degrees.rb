class CreateRiskDegrees < ActiveRecord::Migration
  def change
    create_table :risk_degrees do |t|
      t.string :name
      t.string :level

      t.timestamps
    end
  end
end
