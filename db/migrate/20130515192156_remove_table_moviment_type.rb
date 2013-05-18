class RemoveTableMovimentType < ActiveRecord::Migration
  def change
    remove_column :compras_extra_credit_moviment_types, :moviment_type_id
    drop_table :compras_moviment_types
  end
end
