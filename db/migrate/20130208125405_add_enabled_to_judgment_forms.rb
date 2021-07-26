class AddEnabledToJudgmentForms < ActiveRecord::Migration
  def change
    add_column :compras_judgment_forms, :enabled, :boolean, :default => true
  end
end
