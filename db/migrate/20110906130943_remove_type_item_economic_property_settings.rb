class RemoveTypeItemEconomicPropertySettings < ActiveRecord::Migration
  def up
    drop_table :type_item_economic_property_settings
  end

  def down
    create_table :type_item_economic_property_settings, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end
end