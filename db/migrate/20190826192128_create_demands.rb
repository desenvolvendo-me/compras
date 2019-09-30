class CreateDemands < ActiveRecord::Migration
  def change
    create_table :compras_demands do |t|
      t.integer :year
      t.string :description
      t.text :observation
      t.date :initial_date
      t.date :final_date
      t.string :status, :default => 'created' 

      t.timestamps
    end
  end
end
