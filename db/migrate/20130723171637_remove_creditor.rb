class RemoveCreditor < ActiveRecord::Migration
  def change
    remove_table :compras_extra_budget_pledge_items
    remove_table :compras_extra_budget_pledges
    drop_table :compras_creditors
  end

  protected

  def remove_table(table_name)
    if connection.table_exists? table_name
      drop_table table_name
    end
  end

  def connection
    ActiveRecord::Base.connection
  end
end
