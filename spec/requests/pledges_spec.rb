# encoding: utf-8
require 'spec_helper'

feature "Pledges" do
  background do
    sign_in
  end

  scenario 'create a new pledge' do
    Descriptor.make!(:detran_2012)
    ManagementUnit.make!(:unidade_central)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    reserve_fund = ReserveFund.make!(:detran_2012)
    ExpenseNature.make!(:compra_de_material)
    PledgeCategory.make!(:geral)
    ExpenseKind.make!(:pagamentos)
    PledgeHistoric.make!(:semestral)
    LicitationModality.make!(:publica)
    LicitationProcess.make!(:processo_licitatorio)
    Contract.make!(:primeiro_contrato)
    Contract.make!(:contrato_detran)
    Creditor.make!(:wenderson_sa)
    Material.make!(:arame_farpado)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      fill_modal 'Dotação', :with => '1', :field => 'Código'
      fill_modal 'Desdobramento', :with => '3.0.10.01.11', :field => 'Natureza da despesa'
      fill_in 'Valor', :with => '10,00'
      select 'Patrimonial', :from => 'Tipo de bem'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
      fill_modal 'Contrato de dívida', :with => '2012', :field => 'Ano do contrato'
      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end

      page.should have_disabled_field 'Código'
    end

    within_tab 'Complementar' do
      fill_modal 'Tipo de despesa', :with => 'Pagamentos', :field => 'Descrição'
      fill_modal 'Histórico', :with => 'Semestral', :field => 'Descrição'
      fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
      fill_modal 'Contrato', :with => '001', :field => 'Número do contrato'
      fill_in 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      # should get the value informed on the general tab
      page.should have_disabled_field 'Valor'
      page.should have_field 'Valor', :with => '10,00'

      click_button "Adicionar Item"

      page.should have_disabled_field "Unidade"

      fill_modal 'Item', :with => "Arame farpado", :field => "Descrição"

      # getting the reference unit via javascript
      page.should have_field 'Unidade', :with => "UN"

      fill_in 'Quantidade', :with => "2"
      fill_in 'Valor unitário', :with => "5,00"

      # calculating total item price via javascript
      page.should have_disabled_field 'Valor total dos itens'
      page.should have_field 'Valor total dos itens', :with => "10,00"
    end

    within_tab 'Vencimentos' do
      within '.pledge-parcel:first' do
        fill_in 'Vencimento', :with => I18n.l(Date.current + 1.month)
        fill_in 'Valor', :with => '5,00'
      end

      click_button 'Adicionar Vencimento'

      within '.pledge-parcel:last' do
        fill_in 'Vencimento', :with => I18n.l(Date.current + 1.month)
        fill_in 'Valor', :with => '5,00'
      end

      page.should have_disabled_field 'Valor total das parcelas'
      page.should have_field 'Valor total das parcelas', :with => '10,00'
    end

    click_button 'Salvar'

    page.should have_notice 'Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Descritor', :with => '2012 - Detran'
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Reserva de dotação', :with => "#{reserve_fund.id}/2012"
      page.should have_field 'Unidade gestora', :with => 'Unidade Central'
      page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
      page.should have_select 'Tipo de empenho', :selected => 'Global'
      page.should have_field 'Dotação', :with => budget_allocation.to_s
      page.should have_field 'Valor', :with => '10,00'
      page.should have_field 'Categoria', :with => 'Geral'
      page.should have_select 'Tipo de bem', :selected => 'Patrimonial'
      page.should have_field 'Contrato de dívida', :with => '101'
      page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    end

    within_tab 'Complementar' do
      page.should have_field 'Tipo de despesa', :with => 'Pagamentos'
      page.should have_field 'Histórico', :with => 'Semestral'
      page.should have_field 'Modalidade', :with => 'Pública'
      page.should have_field 'Processo licitatório', :with => '1/2012'
      page.should have_field 'Número da licitação', :with => '1'
      page.should have_field 'Contrato', :with => '001'
      page.should have_field 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      page.should have_field 'Item', :with => "02.02.00001 - Arame farpado"
      page.should have_field 'Quantidade', :with => "2"
      page.should have_field 'Valor unitário', :with => "5,00"
      page.should have_field 'Unidade', :with => "UN"
      page.should have_field 'Valor total', :with => "10,00"
    end

    within_tab 'Vencimentos' do
      page.should have_field 'Valor', :with => '10,00'
      page.should have_field 'Valor total das parcelas', :with => '10,00'

      within '.pledge-parcel:first' do
        page.should have_content 'Parcela 1'
        page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.month)
        page.should have_field 'Valor', :with => '5,00'
      end

      within '.pledge-parcel:last' do
        page.should have_content 'Parcela 2'
        page.should have_field 'Vencimento', :with => I18n.l(Date.current + 1.month)
        page.should have_field 'Valor', :with => '5,00'
      end
    end
  end

  scenario 'should lock expense_nature modal fields and filter when fill reserve_fund' do
    ReserveFund.make!(:reparo_2011)
    ExpenseNature.make!(:vencimento_e_salarios)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Reserva de dotação', :with => '21/02/2012', :field => 'Data'

      within_modal 'Desdobramento' do
        page.should have_disabled_field 'Categoria da despesa'
        page.should have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
        page.should have_disabled_field 'Grupo da despesa'
        page.should have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
        page.should have_disabled_field 'Modalidade da despesa'
        page.should have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
        page.should have_disabled_field 'Elemento da despesa'
        page.should have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'

        scroll_modal_to_bottom :field => 'Elemento da despesa'

        click_button 'Pesquisar'

        page.should_not have_content '3.0.10.01.11'
        page.should have_content '3.0.10.01.12'
      end
    end
  end

  scenario 'should not lock when expense_nature have missing field' do
    expense_nature = ExpenseNature.make(:sem_categoria)
    expense_nature.save(:validate => false)

    BudgetAllocation.make!(:reparo_2011, :expense_nature => expense_nature)
    ExpenseNature.make!(:vencimento_e_salarios)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Dotação', :with => '1', :field => 'Código'

      within_modal 'Desdobramento' do
        page.should have_disabled_field 'Grupo da despesa'
        page.should have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
        page.should have_disabled_field 'Modalidade da despesa'
        page.should have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
        page.should have_disabled_field 'Elemento da despesa'
        page.should have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'

        scroll_modal_to_bottom :field => 'Grupo da despesa'

        click_button 'Pesquisar'

        page.should_not have_content     '3.0.10.01.11'
        page.should have_content '3.0.10.01.12'
      end
    end
  end

  scenario 'should lock expense_nature modal fields and filter modal when fill budget_allocation' do
    BudgetAllocation.make!(:reparo_2011)
    ExpenseNature.make!(:vencimento_e_salarios)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Dotação', :with => '1', :field => 'Código'

      within_modal 'Desdobramento' do
        page.should have_disabled_field 'Categoria da despesa'
        page.should have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
        page.should have_disabled_field 'Grupo da despesa'
        page.should have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
        page.should have_disabled_field 'Modalidade da despesa'
        page.should have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
        page.should have_disabled_field 'Elemento da despesa'
        page.should have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'

        scroll_modal_to_bottom :field => 'Elemento da despesa'

        click_button 'Pesquisar'

        page.should_not have_content '3.0.10.01.11'
        page.should have_content '3.0.10.01.12'
      end
    end
  end

  scenario 'when submit a form with some error should return filtered expense_nature' do
    BudgetAllocation.make!(:reparo_2011)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Dotação', :with => '1', :field => 'Código'
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      within_modal 'Desdobramento' do
        scroll_modal_to_bottom :field => 'Natureza da despesa'

        page.should have_disabled_field 'Categoria da despesa'
        page.should have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
        page.should have_disabled_field 'Grupo da despesa'
        page.should have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
        page.should have_disabled_field 'Modalidade da despesa'
        page.should have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
        page.should have_disabled_field 'Elemento da despesa'
        page.should have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'
      end
    end
  end

  context 'should have modal link' do
    scenario 'when already stored' do
      pledge = Pledge.make!(:empenho)

      navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

      click_link pledge.to_s

      within_tab 'Principal' do
        click_link 'Mais informações'
      end

      page.should have_content 'Informações de: Alocação'
    end

    scenario 'when change budget_allocation' do
      BudgetAllocation.make!(:reparo_2011)

      navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

      click_link 'Criar Empenho'

      within_tab 'Principal' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'

        click_link 'Mais informações'
      end

      page.should have_content 'Informações de: Manutenção e Reparo'
      page.should have_content '2011'
      page.should have_content 'Manutenção e Reparo'
    end
  end

  scenario 'should not have errors on replicated value' do
    Descriptor.make!(:detran_2012)
    ManagementUnit.make!(:unidade_central)
    BudgetAllocation.make!(:alocacao)
    ReserveFund.make!(:detran_2012)
    PledgeCategory.make!(:geral)
    ExpenseKind.make!(:pagamentos)
    PledgeHistoric.make!(:semestral)
    LicitationModality.make!(:publica)
    LicitationProcess.make!(:processo_licitatorio)
    Contract.make!(:primeiro_contrato)
    Creditor.make!(:wenderson_sa)
    Contract.make!(:contrato_detran)
    Material.make!(:arame_farpado)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      fill_modal 'Dotação', :with => '1', :field => 'Código'
      select 'Patrimonial', :from => 'Tipo de bem'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
      fill_modal 'Contrato de dívida', :with => '2012', :field => 'Ano do contrato'
      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end
    end

    within_tab 'Complementar' do
      fill_modal 'Tipo de despesa', :with => 'Pagamentos', :field => 'Descrição'
      fill_modal 'Histórico', :with => 'Semestral', :field => 'Descrição'
      fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
      fill_modal 'Contrato', :with => '001', :field => 'Número do contrato'
      fill_in 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Vencimentos' do
      within '.pledge-parcel:first' do
        fill_in 'Vencimento', :with => I18n.l(Date.current + 1.month)
        fill_in 'Valor', :with => '5,00'
      end

      click_button 'Adicionar Vencimento'

      within '.pledge-parcel:last' do
        fill_in 'Vencimento', :with => I18n.l(Date.current + 1.month)
        fill_in 'Valor', :with => '5,00'
      end
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      page.should have_content 'não pode ficar em branco'
    end

    within_tab 'Itens' do
      page.should_not have_content 'não pode ficar em branco'
    end

    within_tab 'Vencimentos' do
      page.should_not have_content 'não pode ficar em branco'
    end
  end

  scenario 'when create should fill first pledge_parcel date and value' do
    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_in 'Data de emissão', :with => '30/12/2011'
      fill_in 'Valor', :with => '31,66'
    end

    within_tab 'Vencimentos' do
      within '.pledge-parcel:first' do
        page.should have_field 'Vencimento', :with => '30/12/2011'
        page.should have_field 'Valor', :with => '31,66'
      end
    end
  end

  scenario 'when create should not fill first pledge_parcel date and value if already add pledge parcels' do
    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_in 'Data de emissão', :with => '01/11/2011'
      fill_in 'Valor', :with => '31,66'
    end

    within_tab 'Vencimentos' do
      within '.pledge-parcel:first' do
        page.should have_field 'Vencimento', :with => '01/11/2011'
        page.should have_field 'Valor', :with => '31,66'
      end

      click_button 'Adicionar Vencimento'
    end

    within_tab 'Principal' do
      fill_in 'Data de emissão', :with => '10/11/2011'
      fill_in 'Valor', :with => '336,60'
    end

    within_tab 'Vencimentos' do
      within '.pledge-parcel:first' do
        page.should have_field 'Vencimento', :with => '01/11/2011'
        page.should have_field 'Valor', :with => '31,66'
      end
    end
  end

  scenario 'validate expiration_date on pledge_parcels should be greater than emission_date' do
    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
    end

    within_tab 'Vencimentos' do
      fill_in 'Vencimento', :with => I18n.l(Date.current - 10.days)
    end

    click_button 'Salvar'

    within_tab 'Vencimentos' do
      page.should have_content 'deve ser maior ou igual a data de emissão'
    end
  end

  scenario 'should not have error on expiration_date when pledge_parcels is equals than emission_date' do
    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
    end

    within_tab 'Vencimentos' do
      fill_in 'Vencimento', :with => I18n.l(Date.current)
    end

    click_button 'Salvar'

    within_tab 'Vencimentos' do
      page.should_not have_content 'deve ser maior ou igual a data de emissão'
    end
  end

  scenario 'validate expiration_date on pledge_parcels should be greater than last expiration date' do
    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
    end

    within_tab 'Vencimentos' do
      within '.pledge-parcel:first' do
        fill_in 'Vencimento', :with => I18n.l(Date.current + 10.days)
      end

      click_button 'Adicionar Vencimento'

      within '.pledge-parcel:last' do
        fill_in 'Vencimento', :with => I18n.l(Date.current + 5.days)
      end
    end

    click_button 'Salvar'

    within_tab 'Vencimentos' do
      within '.pledge-parcel:last' do
        page.should have_content 'deve ser maior que a data da parcela anterior'
      end
    end
  end

  scenario 'set sequencial pledge parcel number' do
    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Vencimentos' do
      within '.pledge-parcel:first' do
        page.should have_content 'Parcela 1'
      end

      click_button 'Adicionar Vencimento'

      within '.pledge-parcel:last' do
        page.should have_content 'Parcela 2'
      end

      within '.pledge-parcel:first' do
        click_button 'Remover Vencimento'
      end

      within '.pledge-parcel:last' do
        page.should have_content 'Parcela 1'
      end
    end
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    Pledge.make!(:empenho)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    within_records do
      page.find('a').click
    end

    should_not have_button 'Criar Empenho'

    within_tab 'Principal' do
      page.should have_disabled_field 'Descritor'
      page.should have_disabled_field 'Reserva de dotação'
      page.should have_disabled_field 'Unidade gestora'
      page.should have_disabled_field 'Data de emissão'
      page.should have_disabled_field 'Tipo de empenho'
      page.should have_disabled_field 'Dotação'
      page.should have_disabled_field 'Valor'
      page.should have_disabled_field 'Categoria'
      page.should have_disabled_field 'Tipo de bem'
      page.should have_disabled_field 'Contrato de dívida'
      page.should have_disabled_field 'Fornecedor'
    end

    within_tab 'Complementar' do
      page.should have_disabled_field 'Tipo de despesa'
      page.should have_disabled_field 'Histórico'
      page.should have_disabled_field 'Modalidade'
      page.should have_disabled_field 'Processo licitatório'
      page.should have_disabled_field 'Número da licitação'
      page.should have_disabled_field 'Contrato'
      page.should have_disabled_field 'Objeto'
    end

    within_tab 'Itens' do
      page.should have_disabled_field 'Valor'
      page.should have_disabled_field 'Item'
      page.should have_disabled_field 'Unidade'
      page.should have_disabled_field 'Quantidade'
      page.should have_disabled_field 'Valor unitário'
      page.should have_disabled_field 'Valor total'
    end

    within_tab 'Vencimentos' do
      page.should have_disabled_field 'Vencimento'
      page.should have_disabled_field 'Valor'
      page.should_not have_button 'Adicionar Vencimento'
      page.should_not have_button 'Remover Vencimento'
    end
  end

  scenario 'should not have a button to destroy an existent pledge' do
    pledge = Pledge.make!(:empenho)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link pledge.to_s

    page.should_not have_link "Apagar"
  end

  scenario 'Fill budget allocation informations when select reserve fund' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    ReserveFund.make!(:detran_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'

      page.should have_field 'Dotação', :with => budget_allocation.to_s
      page.should have_field 'Saldo da dotação', :with => "479,00"
      page.should have_field 'Saldo reserva', :with => "10,50"
    end
  end

  scenario 'should clear reserve fund when select other budget allocation' do
    BudgetAllocation.make!(:alocacao_extra)
    ReserveFund.make!(:detran_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'

      within_modal 'Dotação' do
        scroll_modal_to_bottom :field => 'Código'

        click_button 'Pesquisar'

        click_record '2011 - Detran'
      end

      page.should have_field 'Reserva de dotação', :with => ''
      page.should have_field 'Saldo reserva', :with => ''
    end
  end

  scenario 'clear reserve_fund_value field when clear' do
    ReserveFund.make!(:detran_2012)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      page.should have_disabled_field 'Saldo reserva'
      page.should have_field 'Saldo reserva', :with => ''

      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'

      page.should have_field 'Saldo reserva', :with => '10,50'

      clear_modal 'Reserva de dotação'

      page.should have_field 'Saldo reserva', :with => ''
    end
  end

  scenario 'getting and cleaning budget delegated fields depending on budget allocation field' do
    BudgetAllocation.make!(:alocacao)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      page.should have_disabled_field 'Saldo da dotação'
      page.should have_disabled_field 'Natureza da despesa'
      page.should have_field 'Saldo da dotação', :with => ''
      page.should have_field 'Natureza da despesa', :with => ''

      fill_modal 'Dotação *', :with => '1', :field => 'Código'

      page.should have_field 'Saldo da dotação', :with => '489,50'
      page.should have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'

      clear_modal 'Dotação *'

      page.should have_field 'Saldo da dotação', :with => ''
      page.should have_field 'Natureza da despesa', :with => ''
    end
  end

  scenario 'clear delegate fields for licitation process' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Complementar' do

      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

      page.should have_field 'Processo licitatório', :with => "1/2012"

      clear_modal 'Processo licitatório'

      page.should have_field 'Processo licitatório', :with => ''
      page.should have_field 'Número da licitação', :with => ''
    end
  end

  scenario 'getting and cleaning signature date depending on contract' do
    Contract.make!(:primeiro_contrato)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

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
    Descriptor.make!(:detran_2012)
    ManagementUnit.make!(:unidade_central)
    BudgetAllocation.make!(:alocacao)
    PledgeCategory.make!(:geral)
    ExpenseKind.make!(:pagamentos)
    PledgeHistoric.make!(:semestral)
    LicitationModality.make!(:publica)
    LicitationProcess.make!(:processo_licitatorio)
    Contract.make!(:primeiro_contrato)
    Material.make!(:arame_farpado)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      fill_modal 'Dotação', :with => '1', :field => 'Código'
      fill_in 'Valor', :with => '300,00'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
    end

    within_tab 'Complementar' do
      fill_modal 'Tipo de despesa', :with => 'Pagamentos', :field => 'Descrição'
      fill_modal 'Histórico', :with => 'Semestral', :field => 'Descrição'
      fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
      fill_modal 'Contrato', :with => '001', :field => 'Número do contrato'
      fill_in 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_modal 'Item', :with => "Arame farpado", :field => "Descrição"
      fill_in 'Quantidade', :with => "1"
      fill_in 'Valor unitário', :with => "100,00"

      click_button "Adicionar Item"

      fill_modal 'pledge_pledge_items_attributes_fresh-1_material', :with => "Arame farpado", :field => "Descrição"
      fill_in 'pledge_pledge_items_attributes_fresh-1_quantity', :with => "2"
      fill_in 'pledge_pledge_items_attributes_fresh-1_unit_price', :with => "100,00"
    end

    click_button 'Salvar'

    within_tab 'Itens' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'should recalculate the total of items on item exclusion' do
    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_in 'Quantidade', :with => "3"
      fill_in 'Valor unitário', :with => "100,00"

      page.should have_field 'Valor total dos itens', :with => "300,00"

      click_button "Adicionar Item"

      within '.pledge-item:first' do
        fill_in 'Quantidade', :with => "4"
        fill_in 'Valor unitário', :with => "20,00"
      end

      page.should have_field 'Valor total dos itens', :with => "380,00"

      within '.pledge-item:last' do
        click_button 'Remover Item'
      end

      page.should have_field 'Valor total dos itens', :with => "80,00"
    end
  end

  scenario 'should have localized budget_allocation_amount and reserve_fund_value for a new pledge' do
    ReserveFund.make!(:reparo_2011)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Reserva de dotação', :with => '21/02/2012', :field => 'Data'

      page.should have_field 'Saldo reserva', :with => "100,50"
      page.should have_field 'Saldo da dotação', :with => "2.899,50"
    end
  end

  scenario 'should have localized budget_allocation_amount and reserve_fund_value for an existent pledge' do
    Pledge.make!(:empenho_saldo_maior_mil)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      page.should have_field 'Saldo reserva', :with => "100,50"
      page.should have_field 'Saldo da dotação', :with => "2.899,50"
    end
  end

  scenario "contracts search should be scoped by kind" do
    Contract.make!(:primeiro_contrato)
    Contract.make!(:contrato_detran)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      within_modal 'Contrato de dívida' do
        scroll_modal_to_bottom :field => 'Ano do contrato'

        click_button 'Pesquisar'

        page.should_not have_content '001'
        page.should have_content '101'

        click_link 'Cancelar'
      end
    end

    within_tab 'Complementar' do
      within_modal 'Contrato' do
        scroll_modal_to_bottom :field => 'Ano do contrato'

        click_button 'Pesquisar'

        page.should have_content '001'
        page.should_not have_content '101'
      end
    end
  end

  scenario 'when create a new pledge with a descriptor that already exist the code should be increased by one' do
    Pledge.make!(:empenho_saldo_maior_mil)
    ReserveFund.make!(:detran_2012)
    ExpenseNature.make!(:compra_de_material)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      within_modal 'Dotação' do
        scroll_modal_to_bottom :field => 'Natureza da despesa'

        click_button 'Pesquisar'

        click_record '2011 - Secretaria de Educação'
      end
      fill_modal 'Desdobramento', :with => '3.0.10.01.12', :field => 'Natureza da despesa'
      fill_in 'Valor', :with => '10,00'
      select 'Patrimonial', :from => 'Tipo de bem'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
      fill_modal 'Contrato de dívida', :with => '2012', :field => 'Ano do contrato'
      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end
    end

    click_button 'Salvar'

    within_records do
      click_link '2 - Secretaria de Educação/2012'
    end

    within_tab 'Principal' do
      page.should have_disabled_field 'Código'
      page.should have_field 'Código', :with => '2'
    end
  end

  scenario 'when create a new pledge with a descriptor that not exist the code should restart at 1' do
    Pledge.make!(:empenho)
    Descriptor.make!(:detran_2011)
ExpenseNature.make!(:compra_de_material)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      within_modal 'Dotação' do
        scroll_modal_to_bottom :field => 'Natureza da despesa'
        click_button 'Pesquisar'
        click_record '2012 - Detran'
      end
      fill_modal 'Desdobramento', :with => '3.0.10.01.11', :field => 'Natureza da despesa'
      fill_in 'Valor', :with => '10,00'
      select 'Patrimonial', :from => 'Tipo de bem'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
      fill_modal 'Contrato de dívida', :with => '2012', :field => 'Ano do contrato'
      within_modal 'Fornecedor' do
        fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'
        click_button 'Pesquisar'
        click_record 'Wenderson Malheiros'
      end
    end

    click_button 'Salvar'

    within_records do
      click_link '1 - Detran/2012'
    end

    within_tab 'Principal' do
      page.should have_disabled_field 'Código'
      page.should have_field 'Código', :with => '1'
    end
  end

  scenario 'validating javascript to item modal' do
    Material.make!(:arame_farpado)

    navigate_through 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      page.should have_disabled_field "Unidade"

      fill_modal 'Item', :with => "Arame farpado", :field => "Descrição"

      page.should have_field 'Unidade', :with => 'UN'

      fill_in 'Item', :with => ''

      page.should have_field 'Unidade', :with => ''
    end
  end
end
