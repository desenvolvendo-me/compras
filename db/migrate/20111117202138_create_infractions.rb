class CreateInfractions < ActiveRecord::Migration
  def change
    create_table :infractions do |t|
      t.string :name
      t.integer :year
      t.string :type_of_infraction
      t.text :legislation
      t.text :penalties_provided
      t.string :guidelines
      t.string :type_of_calculation
      t.decimal :value_for_calculation, :precision => 10, :scale => 2
      t.decimal :max_value,             :precision => 10, :scale => 2
      t.decimal :cash_discount,         :precision => 10, :scale => 2
      t.integer :deadline_for_appeal
      t.integer :deadline_for_payment

      t.timestamps
    end
  end
end
