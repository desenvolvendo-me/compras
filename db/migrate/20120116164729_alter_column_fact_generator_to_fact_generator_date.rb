class AlterColumnFactGeneratorToFactGeneratorDate < ActiveRecord::Migration
  def change
    rename_column :active_debts, :fact_generator, :fact_generator_date
  end
end
