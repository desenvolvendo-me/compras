class AddStartDateToContracts < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :start_date, :date
  end
end
