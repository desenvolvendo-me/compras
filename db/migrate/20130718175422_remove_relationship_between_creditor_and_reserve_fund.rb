class RemoveRelationshipBetweenCreditorAndReserveFund < ActiveRecord::Migration
  def change
    if connection.table_exists? :compras_reserve_funds
      remove_column :compras_reserve_funds, :creditor_id
    end
  end

  protected

  def connection
    ActiveRecord::Base.connection
  end
end
