class AddUnicoRegulatoryActToExpenseNatures < ActiveRecord::Migration
  def change
    add_column :compras_expense_natures, :regulatory_act_id, :integer

    add_index :compras_expense_natures, :regulatory_act_id
    add_foreign_key :compras_expense_natures, :unico_regulatory_acts, column: :regulatory_act_id
  end
end
