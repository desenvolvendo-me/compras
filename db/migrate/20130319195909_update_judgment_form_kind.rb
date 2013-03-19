class UpdateJudgmentFormKind < ActiveRecord::Migration
  def change
    execute <<-SQL
    update
      compras_judgment_forms
    set
      kind = 'lot'
    where
      kind = 'part';
    SQL
  end
end
