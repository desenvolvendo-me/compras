# encoding: utf-8
ExpenseNature.blueprint(:vencimento_e_salarios) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.0.10.01.12' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Vencimentos e Salários' }
  docket { 'Registra o valor das despesas com vencimentos' }
end

ExpenseNature.blueprint(:compra_de_material) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.0.10.01.11' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Compra de Material' }
  docket { 'Registra o valor das despesas com compra de material' }
end

ExpenseNature.blueprint(:aposentadorias_rpps) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.1.90.01.01' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Aposentadorias Custeadas com Recursos do RPPS' }
  docket { 'Registra o valor das despesas com aposentadorias' }
  year { 2012 }
  parent { ExpenseNature.make!(:aposentadorias_reserva_reformas) }
end

ExpenseNature.blueprint(:aposentadorias_reserva) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.1.90.01.02' }
  kind { ExpenseNatureKind::ANALYTICAL }
  description { 'Aposentadorias Custeadas com Recursos da Reserva Remunerada' }
  docket { 'Registra o valor das despesas com aposentadorias' }
  year { 2012 }
  parent { ExpenseNature.make!(:aposentadorias_reserva_reformas) }
end

ExpenseNature.blueprint(:aposentadorias_reserva_reformas) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.1.90.01.00' }
  kind { ExpenseNatureKind::SYNTHETIC }
  description { 'Aposentadorias do RPPS, Reserva Remunerada e Reformas dos Militares' }
  docket { 'Registra o valor das despesas com aposentadorias, reserva e reformas' }
  year { 2012 }
  parent { ExpenseNature.make!(:aplicacoes_diretas) }
end

ExpenseNature.blueprint(:aplicacoes_diretas) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.1.90.00.00' }
  kind { ExpenseNatureKind::BOTH }
  description { 'Aplicações Diretas' }
  docket { 'Registra o valor das aplicações diretas' }
  year { 2012 }
  parent { ExpenseNature.make!(:pessoal_encargos_sociais) }
end

ExpenseNature.blueprint(:pessoal_encargos_sociais) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.1.00.00.00' }
  kind { ExpenseNatureKind::SYNTHETIC }
  description { 'Pessoal e Encargos Sociais' }
  docket { 'Registra o valor das despesas com Pessoal e Encargos Sociais' }
  year { 2012 }
  parent { ExpenseNature.make!(:despesas_correntes) }
end

ExpenseNature.blueprint(:despesas_correntes) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  expense_nature { '3.0.00.00.00' }
  kind { ExpenseNatureKind::SYNTHETIC }
  description { 'Despesas Correntes' }
  docket { 'Registra o valor das despesas' }
  year { 2012 }
end
