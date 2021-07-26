class RemoveAdministrationTypes < ActiveRecord::Migration
  def change
    if connection.table_exists? :compras_budget_structures
      remove_column :compras_budget_structures, :administration_type_id
    end

    if connection.table_exists? :compras_administration_types
      drop_table :compras_administration_types
    end
  end

  protected

  def connection
    ActiveRecord::Base.connection
  end
end
