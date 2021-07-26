class RemoveCustomizationComprasTable < ActiveRecord::Migration
  def change
    if connection.table_exists? 'compras_customizations'
      rename_table :compras_customizations, :financeiro_customizations
      rename_table :compras_customization_data, :financeiro_customization_data
    end
  end


  protected

  def connection
    ActiveRecord::Base.connection
  end
end
