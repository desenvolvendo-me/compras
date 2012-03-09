class AddCodeYearIndexToSupplyAuthorizations < ActiveRecord::Migration
  def change
    add_index :supply_authorizations, [:code, :year], :unique => true
  end
end
