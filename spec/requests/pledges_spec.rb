# encoding: utf-8
require 'spec_helper'

feature "Pledges" do
  background do
    sign_in
  end

  scenario 'create a new pledge' do
    Entity.make!(:detran)
    ManagementUnit.make!(:unidade_central)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    reserve_fund = ReserveFund.make!(:detran_2012)
    PledgeCategory.make!(:geral)
    ExpenseKind.make!(:pagamentos)
    PledgeHistoric.make!(:semestral)
    LicitationModality.make!(:publica)
    management_contract = ManagementContract.make!(:primeiro_contrato)
    Creditor.make!(:nohup)
    founded_debt_contract = FoundedDebtContract.make!(:contrato_detran)
    Material.make!(:cadeira)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Entidade', :with => 'Detran'
      fill_in 'Exercício', :with => '2012'
      fill_modal 'Reserva de dotação', :with => '2012', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      fill_modal 'Dotação', :with => '2012', :field => 'Exercício'
      fill_in 'Valor', :with => '300,00'
      select 'Patrimonial', :from => 'Tipo de bem'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
      fill_modal 'Contrato de dívida fundada', :with => '2012', :field => 'Exercício'
      fill_modal 'Credor', :with => 'Nohup LTDA.'
    end

    within_tab 'Complementar' do
      fill_modal 'Tipo de despesa', :with => 'Pagamentos', :field => 'Descrição'
      fill_modal 'Histórico', :with => 'Semestral', :field => 'Descrição'
      fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
      fill_in 'Número da licitação', :with => '001/2012'
      fill_in 'Número do processo', :with => '002/2013'
      fill_modal 'Contrato', :with => '001', :field => 'Número do contrato'
      fill_in 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      # should get the value informed on the general tab
      page.should have_disabled_field 'Valor'
      page.should have_field 'Valor', :with => "300,00"

      click_button "Adicionar Item"

      page.should have_disabled_field "U. medida"

      fill_modal 'Item', :with => "Cadeira", :field => "Descrição"
      fill_in 'Quantidade', :with => "3"
      fill_in 'Valor unitário', :with => "100,00"

      # getting the reference unit and description via javascript
      page.should have_field 'U. medida', :with => "Unidade"
      page.should have_field 'Descrição', :with => "Cadeira"

      # calculating total item price via javascript
      page.should have_disabled_field 'Valor total dos itens'
      page.should have_field 'Valor total dos itens', :with => "300,00"
    end

    click_button 'Criar Empenho'

    page.should have_notice 'Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Entidade', :with => 'Detran'
      page.should have_field 'Exercício', :with => '2012'
      page.should have_field 'Reserva de dotação', :with => "#{reserve_fund.id}/2012"
      page.should have_field 'Unidade gestora', :with => 'Unidade Central'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
      page.should have_select 'Tipo de empenho', :selected => 'Global'
      page.should have_field 'Dotação', :with => "#{budget_allocation.id}/2012"
      page.should have_field 'Valor', :with => '300,00'
      page.should have_field 'Categoria', :with => 'Geral'
      page.should have_select 'Tipo de bem', :selected => 'Patrimonial'
      page.should have_field 'Contrato de dívida fundada', :with => "#{founded_debt_contract.id}/2012"
      page.should have_field 'Credor', :with => 'Nohup LTDA.'
    end

    within_tab 'Complementar' do
      page.should have_field 'Tipo de despesa', :with => 'Pagamentos'
      page.should have_field 'Histórico', :with => 'Semestral'
      page.should have_field 'Modalidade', :with => 'Pública'
      page.should have_field 'Número da licitação', :with => '001/2012'
      page.should have_field 'Número do processo', :with => '002/2013'
      page.should have_field 'Contrato', :with => "#{management_contract.id}/2012"
      page.should have_field 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      page.should have_field 'Item', :with => "02.02.00001 - Cadeira"
      page.should have_field 'Quantidade', :with => "3"
      page.should have_field 'Valor unitário', :with => "100,00"
      page.should have_field 'U. medida', :with => "Unidade"
      page.should have_field 'Descrição', :with => "Cadeira"
      page.should have_field 'Valor total', :with => "300,00"
    end
  end

  scenario 'update an existent pledge' do
    Pledge.make!(:empenho)
    Entity.make!(:secretaria_de_educacao)
    ManagementUnit.make!(:unidade_auxiliar)
    budget_allocation = BudgetAllocation.make!(:alocacao_extra)
    reserve_fund = ReserveFund.make!(:educacao_2011)
    PledgeCategory.make!(:auxiliar)
    ExpenseKind.make!(:alojamento)
    PledgeHistoric.make!(:anual)
    LicitationModality.make!(:privada)
    management_contract = ManagementContract.make!(:segundo_contrato)
    Creditor.make!(:nobe)
    founded_debt_contract = FoundedDebtContract.make!(:contrato_educacao)
    Material.make!(:manga)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      fill_modal 'Entidade', :with => 'Secretaria de Educação'
      fill_in 'Exercício', :with => '2013'
      fill_modal 'Reserva de dotação', :with => '2011', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Auxiliar', :field => 'Descrição'
      fill_in 'Data de emissão', :with => I18n.l(Date.current + 1)
      select 'Estimativo', :from => 'Tipo de empenho'
      fill_modal 'Dotação', :with => '2011', :field => 'Exercício'
      fill_in 'Valor', :with => '400,00'
      select 'Domínio público', :from => 'Tipo de bem'
      fill_modal 'Categoria', :with => 'Auxiliar', :field => 'Descrição'
      fill_modal 'Contrato de dívida fundada', :with => '2011', :field => 'Exercício'
      fill_modal 'Credor', :with => 'Nobe'
    end

    within_tab 'Complementar' do
      fill_modal 'Tipo de despesa', :with => 'Alojamento', :field => 'Descrição'
      fill_modal 'Histórico', :with => 'Anual', :field => 'Descrição'
      fill_modal 'Modalidade', :with => 'Privada', :field => 'Modalidade'
      fill_in 'Número da licitação', :with => '003/2014'
      fill_in 'Número do processo', :with => '004/2015'
      fill_modal 'Contrato', :with => '002', :field => 'Número do contrato'
      fill_in 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      fill_modal 'Item', :with => "Manga", :field => "Descrição"
      page.should have_field 'U. medida', :with => "Quilos"
      fill_in 'Quantidade', :with => "200"
      fill_in 'Valor unitário', :with => "2,00"
    end

    click_button 'Atualizar Empenho'

    page.should have_notice 'Empenho editado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Entidade', :with => 'Secretaria de Educação'
      page.should have_field 'Exercício', :with => '2013'
      page.should have_field 'Reserva de dotação', :with => "#{reserve_fund.id}/2011"
      page.should have_field 'Unidade gestora', :with => 'Unidade Auxiliar'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current + 1)
      page.should have_select 'Tipo de empenho', :selected => 'Estimativo'
      page.should have_field 'Dotação', :with => "#{budget_allocation.id}/2011"
      page.should have_field 'Valor', :with => '400,00'
      page.should have_field 'Categoria', :with => 'Auxiliar'
      page.should have_select 'Tipo de bem', :selected => 'Domínio público'
      page.should have_field 'Contrato de dívida fundada', :with => "#{founded_debt_contract.id}/2011"
      page.should have_field 'Credor', :with => 'Nobe'
    end

    within_tab 'Complementar' do
      page.should have_field 'Tipo de despesa', :with => 'Alojamento'
      page.should have_field 'Histórico', :with => 'Anual'
      page.should have_field 'Modalidade', :with => 'Privada'
      page.should have_field 'Número da licitação', :with => '003/2014'
      page.should have_field 'Número do processo', :with => '004/2015'
      page.should have_field 'Contrato', :with => "#{management_contract.id}/2013"
      page.should have_field 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      page.should have_field 'Valor', :with => "400,00"
      page.should have_field 'Item', :with => "01.01.00001 - Manga"

      # should not change the description because it is readonly
      page.should have_field 'Descrição', :with => "desc cadeiras"
      page.should have_field 'U. medida', :with => "Quilos"
      page.should have_field 'Quantidade', :with => "200"
      page.should have_field 'Valor unitário', :with => "2,00"
      page.should have_field 'Valor total', :with => "400,00"
    end
  end

  scenario 'destroy an existent pledge' do
    Pledge.make!(:empenho)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Empenho apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '2012'
    page.should_not have_content I18n.l(Date.current)
    page.should_not have_content '9,99'
  end

  scenario 'clear reserve_fund_value field when clear' do
    reserve_fund = ReserveFund.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      page.should have_disabled_field 'Saldo reserva'
      page.should have_field 'Saldo reserva', :with => ''

      fill_modal 'Reserva de dotação', :with => '2012', :field => 'Exercício'

      page.should have_field 'Saldo reserva', :with => '10,50'

      clear_modal 'Reserva de dotação'

      page.should have_field 'Saldo reserva', :with => ''
    end
  end

  scenario 'getting and cleaning budget delegated fields depending on budget allocation field' do
    budget_allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      page.should have_disabled_field 'Saldo da dotação'
      page.should have_disabled_field 'Função'
      page.should have_disabled_field 'Subfunção'
      page.should have_disabled_field 'Programa'
      page.should have_disabled_field 'Ação'
      page.should have_disabled_field 'Organograma'
      page.should have_disabled_field 'Natureza da despesa'
      page.should have_field 'Saldo da dotação', :with => ''
      page.should have_field 'Função', :with => ''
      page.should have_field 'Subfunção', :with => ''
      page.should have_field 'Programa', :with => ''
      page.should have_field 'Ação', :with => ''
      page.should have_field 'Organograma', :with => ''
      page.should have_field 'Natureza da despesa', :with => ''

      fill_modal 'Dotação', :with => '2012', :field => 'Exercício'

      page.should have_field 'Saldo da dotação', :with => '500,00'
      page.should have_field 'Função', :with => '04 - Administração'
      page.should have_field 'Subfunção', :with => '01 - Administração Geral'
      page.should have_field 'Programa', :with => 'Habitação'
      page.should have_field 'Ação', :with => 'Ação Governamental'
      page.should have_field 'Organograma', :with => '02.00 - Secretaria de Educação'
      page.should have_field 'Natureza da despesa', :with => '3.1.90.11.01.00.00.00'

      clear_modal 'Dotação'

      page.should have_field 'Saldo da dotação', :with => ''
      page.should have_field 'Função', :with => ''
      page.should have_field 'Subfunção', :with => ''
      page.should have_field 'Programa', :with => ''
      page.should have_field 'Ação', :with => ''
      page.should have_field 'Organograma', :with => ''
      page.should have_field 'Natureza da despesa', :with => ''
    end
  end

  scenario 'getting and cleaning signature date depending on contract' do
    ManagementContract.make!(:primeiro_contrato)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Complementar' do
      page.should have_disabled_field 'Data do contrato'
      page.should have_field 'Data do contrato', :with => ''

      fill_modal 'Contrato', :with => '001', :field => 'Número do contrato'

      page.should have_field 'Data do contrato', :with => "23/02/2012"

      clear_modal 'Contrato'

      page.should have_field 'Data do contrato', :with => ''
    end
  end

  scenario 'trying to create a new pledge with duplicated items to ensure the error' do
    Entity.make!(:detran)
    ManagementUnit.make!(:unidade_central)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    PledgeCategory.make!(:geral)
    ExpenseKind.make!(:pagamentos)
    PledgeHistoric.make!(:semestral)
    LicitationModality.make!(:publica)
    management_contract = ManagementContract.make!(:primeiro_contrato)
    Material.make!(:cadeira)

    click_link 'Contabilidade'

    click_link 'Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Entidade', :with => 'Detran'
      fill_in 'Exercício', :with => '2012'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      fill_modal 'Dotação', :with => '2012', :field => 'Exercício'
      fill_in 'Valor', :with => '300,00'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
    end

    within_tab 'Complementar' do
      fill_modal 'Tipo de despesa', :with => 'Pagamentos', :field => 'Descrição'
      fill_modal 'Histórico', :with => 'Semestral', :field => 'Descrição'
      fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
      fill_in 'Número da licitação', :with => '001/2012'
      fill_in 'Número do processo', :with => '002/2013'
      fill_modal 'Contrato', :with => '001', :field => 'Número do contrato'
      fill_in 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_modal 'Item', :with => "Cadeira", :field => "Descrição"
      fill_in 'Quantidade', :with => "1"
      fill_in 'Valor unitário', :with => "100,00"

      click_button "Adicionar Item"

      fill_modal 'pledge_pledge_items_attributes_fresh-1_material', :with => "Cadeira", :field => "Descrição"
      fill_in 'pledge_pledge_items_attributes_fresh-1_quantity', :with => "2"
      fill_in 'pledge_pledge_items_attributes_fresh-1_unit_price', :with => "100,00"
    end

    click_button 'Criar Empenho'

    within_tab 'Itens' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'should recalculate the total of items on item exclusion' do
    click_link 'Contabilidade'

    click_link 'Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_in 'Quantidade', :with => "3"
      fill_in 'Valor unitário', :with => "100,00"

      page.should have_field 'Valor total dos itens', :with => "300,00"

      click_button "Adicionar Item"

      fill_in 'pledge_pledge_items_attributes_fresh-1_quantity', :with => "4"
      fill_in 'pledge_pledge_items_attributes_fresh-1_unit_price', :with => "20,00"

      page.should have_field 'Valor total dos itens', :with => "380,00"

      click_button 'Remover Item'

      page.should have_field 'Valor total dos itens', :with => "80,00"
    end
  end
end
