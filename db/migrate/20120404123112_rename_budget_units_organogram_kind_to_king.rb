class RenameBudgetUnitsOrganogramKindToKing < ActiveRecord::Migration
  def change
    rename_column :budget_units, :organogram_kind, :kind
  end
end
