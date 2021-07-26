class RemoveRelationshipBetweenCreditorAndPrecatories < ActiveRecord::Migration
  def change
    if connection.table_exists? :compras_precatories
      remove_column :compras_precatories, :creditor_id
    end
  end

  protected

  def connection
    ActiveRecord::Base.connection
  end
end
