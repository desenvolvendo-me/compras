class CreateTypeItemEconomicPropertySettings < ActiveRecord::Migration
  def change
    create_table :type_item_economic_property_settings do |t|
      t.string :name

      t.timestamps
    end
  end
end
