class RenameExpenseNaturesTable < ActiveRecord::Migration
  class RegulatoryAct < Compras::Model; end

  def up
    if Rails.env == 'development' || Rails.env == 'test'
      rename_table :compras_expense_natures, :accounting_expense_natures

      add_column :accounting_expense_natures, :year, :integer
      add_column :accounting_expense_natures, :parent_id, :integer

      add_index "accounting_expense_natures", ["parent_id"], :name => "ac_expense_natures_on_parent_id"

      add_foreign_key "accounting_expense_natures", "accounting_expense_natures", :name => "ac_expense_natures_parent_id_fk", :column => "parent_id"

      remove_columns :accounting_expense_natures, :expense_category_id, :expense_group_id,
                     :expense_modality_id, :expense_element_id, :expense_split, :descriptor_id
    end

    if Rails.env == 'development'
      unless RegulatoryAct.any?
        execute <<-SQL
          INSERT INTO compras_regulatory_acts VALUES (1, '0001', 1, '2011-12-30', '2011-12-30', '2012-01-01', '2012-12-31', 'Institui o orçamento anual para o exercício de 2012', 0.00, 0.00, 0.00, '2013-04-03 18:12:36.103988', '2013-04-03 18:12:36.103988', 1, '2011-12-30');
        SQL
      end

      execute <<-SQL
        INSERT INTO accounting_expense_natures VALUES ((select COALESCE(max(id), 0) + 1 from accounting_expense_natures), 1, '3.0.00.00.00', 'synthetic', 'Despesas Correntes', 'Registra o valor das despesas', '2013-04-03 15:58:39.740004', '2013-04-03 15:58:39.740004', 2012, NULL);
        INSERT INTO accounting_expense_natures VALUES ((select COALESCE(max(id), 0) + 1 from accounting_expense_natures), 1, '3.1.00.00.00', 'synthetic', 'Pessoal e Encargos Sociais', 'Registra o valor das despesas com Pessoal e Encargos Sociais', '2013-04-03 15:58:39.755041', '2013-04-03 15:58:39.755041', 2012, (Select max(id) from accounting_expense_natures));
        INSERT INTO accounting_expense_natures VALUES ((select COALESCE(max(id), 0) + 1 from accounting_expense_natures), 1, '3.1.90.00.00', 'both', 'Aplicações Diretas', 'Registra o valor das aplicações diretas', '2013-04-03 15:58:39.760617', '2013-04-03 15:58:39.760617', 2012, (Select max(id) from accounting_expense_natures));
        INSERT INTO accounting_expense_natures VALUES ((select COALESCE(max(id), 0) + 1 from accounting_expense_natures), 1, '3.1.90.01.00', 'synthetic', 'Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares', 'Registra o valor das despesas com aposentadorias, reserva e reformas', '2013-04-03 15:58:39.767925', '2013-04-03 15:58:39.767925', 2012, (Select max(id) from accounting_expense_natures));
        INSERT INTO accounting_expense_natures VALUES ((select COALESCE(max(id), 0) + 1 from accounting_expense_natures), 1, '3.1.90.01.01', 'analytical', 'Aposentadorias Custeadas com Recursos do RPPS', 'Registra o valor das despesas com aposentadorias', '2013-04-03 15:58:39.773091', '2013-04-03 15:58:39.773091', 2012, (Select max(id) from accounting_expense_natures));
      SQL
    end
  end
end
