class ChangeSomeRegulatoryActsColumnsToDefaultZero < ActiveRecord::Migration
  def change
    change_table :regulatory_acts do |t|
      t.change :budget_law_percent, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :revenue_antecipation_percent, :decimal, :precision => 10, :scale => 2, :default => 0.0
      t.change :authorized_debt_value, :decimal, :precision => 10, :scale => 2, :default => 0.0
    end
  end
end
