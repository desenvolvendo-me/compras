class DropTableCondominiumTypesAndAssociations < ActiveRecord::Migration
  def change
    remove_foreign_key :condominiums, :condominium_types
    remove_index :condominiums, :column => :condominium_type_id
    drop_table :condominium_types
    remove_column :condominiums, :condominium_type_id
  end
end
