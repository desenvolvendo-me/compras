class AddTypeOfCalculationToPriceCollection < ActiveRecord::Migration
  def change
    add_column :price_collections, :type_of_calculation, :string
  end
end
