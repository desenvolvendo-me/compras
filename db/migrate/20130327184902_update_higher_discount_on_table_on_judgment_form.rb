class UpdateHigherDiscountOnTableOnJudgmentForm < ActiveRecord::Migration
  def change
    execute <<-SQL
      UPDATE compras_judgment_forms
      SET description = 'Menor Preço - Maior Desconto sobre Tabela'
      WHERE description = 'Maior Desconto Sobre Tabela'
    SQL
  end
end
