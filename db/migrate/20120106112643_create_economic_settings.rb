class CreateEconomicSettings < ActiveRecord::Migration
  def change
    create_table :economic_settings do |t|
      
      t.timestamps
    end
  end
end
