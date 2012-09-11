class RenameRecordPriceBudgetStructure < ActiveRecord::Migration
  def change
    rename_table :compras_record_price_budget_structures,
                 :compras_price_registration_budget_structures

    rename_column :compras_price_registration_budget_structures,
                  :record_price_item_id, :price_registration_item_id
  end
end
