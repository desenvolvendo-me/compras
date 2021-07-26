class AddUnicoCreditorToPrecatory < ActiveRecord::Migration
  def change
    if connection.table_exists? :compras_precatories
      add_column :compras_precatories, :creditor_id, :integer

      add_index :compras_precatories, :creditor_id
      add_foreign_key :compras_precatories, :unico_creditors, column: :creditor_id
    end
  end

  protected

  def connection
    ActiveRecord::Base.connection
  end
end
