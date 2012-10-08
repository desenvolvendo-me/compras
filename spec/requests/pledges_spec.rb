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
    Material.make!(:antivirus)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

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
      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'

      expect(page).to have_disabled_field 'Código'
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
      expect(page).to have_disabled_field 'Valor'
      expect(page).to have_field 'Valor', :with => '10,00'

      click_button "Adicionar Item"

      expect(page).to have_disabled_field "Unidade"

      fill_modal 'Item', :with => "Arame farpado", :field => "Descrição"

      # getting the reference unit via javascript
      expect(page).to have_field 'Unidade', :with => "UN"

      fill_in 'Quantidade', :with => "2"
      fill_in 'Valor unitário', :with => "5,00"

      # calculating total item price via javascript
      expect(page).to have_disabled_field 'Valor total dos itens'
      expect(page).to have_field 'Valor total dos itens', :with => "10,00"

      click_button "Adicionar Item"

      fill_modal 'Item', :with => "Antivirus", :field => "Descrição"

      expect(page).to have_field 'Unidade', :with => "UN"

      fill_in 'Quantidade', :with => "1"
      fill_in 'Valor unitário', :with => "1,00"
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Empenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2012 - Detran'
      expect(page).to have_field 'Código', :with => '1'
      expect(page).to have_field 'Reserva de dotação', :with => "#{reserve_fund.id}/2012"
      expect(page).to have_field 'Unidade gestora', :with => 'Unidade Central'
      expect(page).to have_field 'Data de emissão', :with => I18n.l(Date.current)
      expect(page).to have_select 'Tipo de empenho', :selected => 'Global'
      expect(page).to have_field 'Dotação', :with => budget_allocation.to_s
      expect(page).to have_field 'Valor', :with => '10,00'
      expect(page).to have_field 'Categoria', :with => 'Geral'
      expect(page).to have_select 'Tipo de bem', :selected => 'Patrimonial'
      expect(page).to have_field 'Contrato de dívida', :with => '101'
      expect(page).to have_field 'Fornecedor', :with => 'Wenderson Malheiros'
    end

    within_tab 'Complementar' do
      expect(page).to have_field 'Tipo de despesa', :with => 'Pagamentos'
      expect(page).to have_field 'Histórico', :with => 'Semestral'
      expect(page).to have_field 'Modalidade', :with => 'Pública'
      expect(page).to have_field 'Processo licitatório', :with => '1/2012'
      expect(page).to have_field 'Número da licitação', :with => '1'
      expect(page).to have_field 'Contrato', :with => '001'
      expect(page).to have_field 'Objeto', :with => 'Objeto de empenho'
    end

    within_tab 'Itens' do
      expect(page).to have_field 'Item', :with => "02.02.00001 - Arame farpado"
      expect(page).to have_field 'Quantidade', :with => "2"
      expect(page).to have_field 'Valor unitário', :with => "5,00"
      expect(page).to have_field 'Unidade', :with => "UN"
      expect(page).to have_field 'Valor total', :with => "10,00"
    end
  end

  scenario 'should lock expense_nature modal fields and filter when fill reserve_fund' do
    ReserveFund.make!(:reparo_2011)
    ExpenseNature.make!(:vencimento_e_salarios)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Reserva de dotação', :with => '21/02/2012', :field => 'Data'

      within_modal 'Desdobramento' do
        expect(page).to have_disabled_field 'Categoria da despesa'
        expect(page).to have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
        expect(page).to have_disabled_field 'Grupo da despesa'
        expect(page).to have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
        expect(page).to have_disabled_field 'Modalidade da despesa'
        expect(page).to have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
        expect(page).to have_disabled_field 'Elemento da despesa'
        expect(page).to have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'

        click_button 'Pesquisar'

        expect(page).to_not have_content '3.0.10.01.11'
        expect(page).to have_content '3.0.10.01.12'
      end
    end
  end

  scenario 'should lock expense_nature modal fields and filter modal when fill budget_allocation' do
    BudgetAllocation.make!(:reparo_2011)
    ExpenseNature.make!(:vencimento_e_salarios)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Dotação', :with => '1', :field => 'Código'

      within_modal 'Desdobramento' do
        expect(page).to have_disabled_field 'Categoria da despesa'
        expect(page).to have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
        expect(page).to have_disabled_field 'Grupo da despesa'
        expect(page).to have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
        expect(page).to have_disabled_field 'Modalidade da despesa'
        expect(page).to have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
        expect(page).to have_disabled_field 'Elemento da despesa'
        expect(page).to have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'

        click_button 'Pesquisar'

        expect(page).to_not have_content '3.0.10.01.11'
        expect(page).to have_content '3.0.10.01.12'
      end
    end
  end

  context 'should filter missing fields using nil' do
    scenario 'to expense_category' do
      expense_nature = ExpenseNature.make(:compra_de_material, :expense_category => nil)
      expense_nature.save(:validate => false)

      budget_allocation = BudgetAllocation.make(:reparo_2011, :expense_nature => expense_nature)
      budget_allocation.save(:validate => false)

      other_expense_nature = ExpenseNature.make(:vencimento_e_salarios, :expense_category => nil)
      other_expense_nature.save(:validate => false)

      navigate 'Contabilidade > Execução > Empenho > Empenhos'

      click_link 'Criar Empenho'

      within_tab 'Principal' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'

        within_modal 'Desdobramento' do
          expect(page).to have_disabled_field 'Categoria da despesa'
          expect(page).to have_field 'Categoria da despesa', :with => ''
          expect(page).to have_disabled_field 'Grupo da despesa'
          expect(page).to have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
          expect(page).to have_disabled_field 'Modalidade da despesa'
          expect(page).to have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
          expect(page).to have_disabled_field 'Elemento da despesa'
          expect(page).to have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'

          click_button 'Pesquisar'

          expect(page).to have_content '3.0.10.01.12'
          expect(page).to_not have_content '3.0.10.01.10'
        end
      end
    end

    scenario 'to expense_group' do
      expense_nature = ExpenseNature.make(:compra_de_material, :expense_group => nil)
      expense_nature.save(:validate => false)

      budget_allocation = BudgetAllocation.make(:reparo_2011, :expense_nature => expense_nature)
      budget_allocation.save(:validate => false)

      other_expense_nature = ExpenseNature.make(:vencimento_e_salarios, :expense_group => nil)
      other_expense_nature.save(:validate => false)

      navigate 'Contabilidade > Execução > Empenho > Empenhos'

      click_link 'Criar Empenho'

      within_tab 'Principal' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'

        within_modal 'Desdobramento' do
          expect(page).to have_disabled_field 'Categoria da despesa'
          expect(page).to have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
          expect(page).to have_disabled_field 'Grupo da despesa'
          expect(page).to have_field 'Grupo da despesa', :with => ''
          expect(page).to have_disabled_field 'Modalidade da despesa'
          expect(page).to have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
          expect(page).to have_disabled_field 'Elemento da despesa'
          expect(page).to have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'

          click_button 'Pesquisar'

          expect(page).to have_content '3.0.10.01.12'
          expect(page).to_not have_content '3.0.10.01.10'
        end
      end
    end

    scenario 'to expense_modality' do
      expense_nature = ExpenseNature.make(:compra_de_material, :expense_modality => nil)
      expense_nature.save(:validate => false)

      budget_allocation = BudgetAllocation.make(:reparo_2011, :expense_nature => expense_nature)
      budget_allocation.save(:validate => false)

      other_expense_nature = ExpenseNature.make(:vencimento_e_salarios, :expense_modality => nil)
      other_expense_nature.save(:validate => false)

      navigate 'Contabilidade > Execução > Empenho > Empenhos'

      click_link 'Criar Empenho'

      within_tab 'Principal' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'

        within_modal 'Desdobramento' do
          expect(page).to have_disabled_field 'Categoria da despesa'
          expect(page).to have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
          expect(page).to have_disabled_field 'Grupo da despesa'
          expect(page).to have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
          expect(page).to have_disabled_field 'Modalidade da despesa'
          expect(page).to have_field 'Modalidade da despesa', :with => ''
          expect(page).to have_disabled_field 'Elemento da despesa'
          expect(page).to have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'

          click_button 'Pesquisar'

          expect(page).to have_content '3.0.10.01.12'
          expect(page).to_not have_content '3.0.10.01.10'
        end
      end
    end

    scenario 'to expense_element' do
      expense_nature = ExpenseNature.make(:compra_de_material, :expense_element => nil)
      expense_nature.save(:validate => false)

      budget_allocation = BudgetAllocation.make(:reparo_2011, :expense_nature => expense_nature)
      budget_allocation.save(:validate => false)

      other_expense_nature = ExpenseNature.make(:vencimento_e_salarios, :expense_element => nil)
      other_expense_nature.save(:validate => false)

      navigate 'Contabilidade > Execução > Empenho > Empenhos'

      click_link 'Criar Empenho'

      within_tab 'Principal' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'

        within_modal 'Desdobramento' do
          expect(page).to have_disabled_field 'Categoria da despesa'
          expect(page).to have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
          expect(page).to have_disabled_field 'Grupo da despesa'
          expect(page).to have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
          expect(page).to have_disabled_field 'Modalidade da despesa'
          expect(page).to have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
          expect(page).to have_disabled_field 'Elemento da despesa'
          expect(page).to have_field 'Elemento da despesa', :with => ''

          click_button 'Pesquisar'

          expect(page).to have_content '3.0.10.01.12'
          expect(page).to_not have_content '3.0.10.01.10'
        end
      end
    end
  end

  scenario 'when submit a form with some error should return filtered expense_nature' do
    BudgetAllocation.make!(:reparo_2011)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Dotação', :with => '1', :field => 'Código'
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      within_modal 'Desdobramento' do
        expect(page).to have_disabled_field 'Categoria da despesa'
        expect(page).to have_field 'Categoria da despesa', :with => '3 - DESPESA CORRENTE'
        expect(page).to have_disabled_field 'Grupo da despesa'
        expect(page).to have_field 'Grupo da despesa', :with => '0 - RESTOS A PAGAR'
        expect(page).to have_disabled_field 'Modalidade da despesa'
        expect(page).to have_field 'Modalidade da despesa', :with => '10 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
        expect(page).to have_disabled_field 'Elemento da despesa'
        expect(page).to have_field 'Elemento da despesa', :with => '1 - APOSENTADORIAS'
      end
    end
  end

  context 'should have modal link' do
    scenario 'when already stored' do
      pledge = Pledge.make!(:empenho)

      navigate 'Contabilidade > Execução > Empenho > Empenhos'

      click_link pledge.to_s

      within_tab 'Principal' do
        click_link 'Mais informações'
      end

      expect(page).to have_content 'Informações de: 1 - Alocação'
    end

    scenario 'when change budget_allocation' do
      BudgetAllocation.make!(:reparo_2011)

      navigate 'Contabilidade > Execução > Empenho > Empenhos'

      click_link 'Criar Empenho'

      within_tab 'Principal' do
        fill_modal 'Dotação', :with => '1', :field => 'Código'

        click_link 'Mais informações'
      end

      expect(page).to have_content 'Informações de: 1.29 - Manutenção e Reparo'
      expect(page).to have_content '2011'
      expect(page).to have_content 'Manutenção e Reparo'
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

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

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
      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'
    end

    within_tab 'Complementar' do
      fill_modal 'Tipo de despesa', :with => 'Pagamentos', :field => 'Descrição'
      fill_modal 'Histórico', :with => 'Semestral', :field => 'Descrição'
      fill_modal 'Modalidade', :with => 'Pública', :field => 'Modalidade'
      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'
      fill_modal 'Contrato', :with => '001', :field => 'Número do contrato'
      fill_in 'Objeto', :with => 'Objeto de empenho'
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      expect(page).to have_content 'não pode ficar em branco'
    end

    within_tab 'Itens' do
      expect(page).to_not have_content 'não pode ficar em branco'
    end
  end

  scenario 'should have all fields disabled when editing an existent pledge' do
    Pledge.make!(:empenho)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    within_records do
      page.find('a').click
    end

    should_not have_button 'Criar Empenho'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Descritor'
      expect(page).to have_disabled_field 'Reserva de dotação'
      expect(page).to have_disabled_field 'Unidade gestora'
      expect(page).to have_disabled_field 'Data de emissão'
      expect(page).to have_disabled_field 'Tipo de empenho'
      expect(page).to have_disabled_field 'Dotação'
      expect(page).to have_disabled_field 'Valor'
      expect(page).to have_disabled_field 'Categoria'
      expect(page).to have_disabled_field 'Tipo de bem'
      expect(page).to have_disabled_field 'Contrato de dívida'
      expect(page).to have_disabled_field 'Fornecedor'
    end

    within_tab 'Complementar' do
      expect(page).to have_disabled_field 'Tipo de despesa'
      expect(page).to have_disabled_field 'Histórico'
      expect(page).to have_disabled_field 'Modalidade'
      expect(page).to have_disabled_field 'Processo licitatório'
      expect(page).to have_disabled_field 'Número da licitação'
      expect(page).to have_disabled_field 'Contrato'
      expect(page).to have_disabled_field 'Objeto'
    end

    within_tab 'Itens' do
      expect(page).to have_disabled_field 'Valor'
      expect(page).to have_disabled_field 'Item'
      expect(page).to have_disabled_field 'Unidade'
      expect(page).to have_disabled_field 'Quantidade'
      expect(page).to have_disabled_field 'Valor unitário'
      expect(page).to have_disabled_field 'Valor total'
    end
  end

  scenario 'should not have a button to destroy an existent pledge' do
    pledge = Pledge.make!(:empenho)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link pledge.to_s

    expect(page).to_not have_link "Apagar"
  end

  scenario 'Fill budget allocation informations when select reserve fund' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    ReserveFund.make!(:detran_2012)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'

      expect(page).to have_field 'Dotação', :with => budget_allocation.to_s
      expect(page).to have_field 'Saldo da dotação', :with => "479,00"
      expect(page).to have_field 'Saldo reserva', :with => "10,50"
    end
  end

  scenario 'should clear reserve fund when select other budget allocation' do
    BudgetAllocation.make!(:alocacao_extra)
    ReserveFund.make!(:detran_2012)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'

      within_modal 'Dotação' do
        click_button 'Pesquisar'

        click_record '2011 - Detran'
      end

      expect(page).to have_field 'Reserva de dotação', :with => ''
      expect(page).to have_field 'Saldo reserva', :with => ''
    end
  end

  scenario 'clear reserve_fund_value field when clear' do
    ReserveFund.make!(:detran_2012)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Saldo reserva'
      expect(page).to have_field 'Saldo reserva', :with => ''

      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'

      expect(page).to have_field 'Saldo reserva', :with => '10,50'

      clear_modal 'Reserva de dotação'

      expect(page).to have_field 'Saldo reserva', :with => ''
    end
  end

  scenario 'getting and cleaning budget delegated fields depending on budget allocation field' do
    BudgetAllocation.make!(:alocacao)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Saldo da dotação'
      expect(page).to have_disabled_field 'Natureza da despesa'
      expect(page).to have_field 'Saldo da dotação', :with => ''
      expect(page).to have_field 'Natureza da despesa', :with => ''

      fill_modal 'Dotação *', :with => '1', :field => 'Código'

      expect(page).to have_field 'Saldo da dotação', :with => '489,50'
      expect(page).to have_field 'Natureza da despesa', :with => '3.0.10.01.12 - Vencimentos e Salários'

      clear_modal 'Dotação *'

      expect(page).to have_field 'Saldo da dotação', :with => ''
      expect(page).to have_field 'Natureza da despesa', :with => ''
    end
  end

  scenario 'clear delegate fields for licitation process' do
    LicitationProcess.make!(:processo_licitatorio)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Complementar' do

      fill_modal 'Processo licitatório', :with => '2012', :field => 'Ano'

      expect(page).to have_field 'Processo licitatório', :with => "1/2012"

      clear_modal 'Processo licitatório'

      expect(page).to have_field 'Processo licitatório', :with => ''
      expect(page).to have_field 'Número da licitação', :with => ''
    end
  end

  scenario 'getting and cleaning signature date depending on contract' do
    Contract.make!(:primeiro_contrato)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Complementar' do
      expect(page).to have_disabled_field 'Data do contrato'
      expect(page).to have_field 'Data do contrato', :with => ''

      fill_modal 'Contrato', :with => '001', :field => 'Número do contrato'

      expect(page).to have_field 'Data do contrato', :with => "23/02/2012"

      clear_modal 'Contrato'

      expect(page).to have_field 'Data do contrato', :with => ''
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

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

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
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'should recalculate the total of items on item exclusion' do
    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      fill_in 'Quantidade', :with => "3"
      fill_in 'Valor unitário', :with => "100,00"

      expect(page).to have_field 'Valor total dos itens', :with => "300,00"

      click_button "Adicionar Item"

      within '.pledge-item:first' do
        fill_in 'Quantidade', :with => "4"
        fill_in 'Valor unitário', :with => "20,00"
      end

      expect(page).to have_field 'Valor total dos itens', :with => "380,00"

      within '.pledge-item:last' do
        click_button 'Remover Item'
      end

      expect(page).to have_field 'Valor total dos itens', :with => "80,00"
    end
  end

  scenario 'should have localized budget_allocation_amount and reserve_fund_value for a new pledge' do
    ReserveFund.make!(:reparo_2011)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Reserva de dotação', :with => '21/02/2012', :field => 'Data'

      expect(page).to have_field 'Saldo reserva', :with => "100,50"
      expect(page).to have_field 'Saldo da dotação', :with => "2.899,50"
    end
  end

  scenario 'should have localized budget_allocation_amount and reserve_fund_value for an existent pledge' do
    Pledge.make!(:empenho_saldo_maior_mil)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Saldo reserva', :with => "100,50"
      expect(page).to have_field 'Saldo da dotação', :with => "2.899,50"
    end
  end

  scenario "contracts search should be scoped by kind" do
    Contract.make!(:primeiro_contrato)
    Contract.make!(:contrato_detran)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      within_modal 'Contrato de dívida' do
        click_button 'Pesquisar'

        expect(page).to_not have_content '001'
        expect(page).to have_content '101'

        click_link 'Voltar'
      end
    end

    within_tab 'Complementar' do
      within_modal 'Contrato' do
        click_button 'Pesquisar'

        expect(page).to have_content '001'
        expect(page).to_not have_content '101'
      end
    end
  end

  scenario 'when create a new pledge with a descriptor that already exist the code should be increased by one' do
    Pledge.make!(:empenho_saldo_maior_mil)
    ReserveFund.make!(:detran_2012)
    ExpenseNature.make!(:compra_de_material)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      within_modal 'Dotação' do
        click_button 'Pesquisar'

        click_record '2011 - Secretaria de Educação'
      end
      fill_modal 'Desdobramento', :with => '3.0.10.01.12', :field => 'Natureza da despesa'
      fill_in 'Valor', :with => '10,00'
      select 'Patrimonial', :from => 'Tipo de bem'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
      fill_modal 'Contrato de dívida', :with => '2012', :field => 'Ano do contrato'
      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'
    end

    click_button 'Salvar'

    within_records do
      click_link '2 - Detran/2011'
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '2'
    end
  end

  scenario 'when create a new pledge with a descriptor that not exist the code should restart at 1' do
    Pledge.make!(:empenho)
    Descriptor.make!(:detran_2011)
    ExpenseNature.make!(:compra_de_material)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Unidade gestora', :with => 'Unidade Central', :field => 'Descrição'
      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'
      fill_in 'Data de emissão', :with => I18n.l(Date.current)
      select 'Global', :from => 'Tipo de empenho'
      within_modal 'Dotação' do
        click_button 'Pesquisar'
        click_record '2012 - Detran'
      end
      fill_modal 'Desdobramento', :with => '3.0.10.01.11', :field => 'Natureza da despesa'
      fill_in 'Valor', :with => '10,00'
      select 'Patrimonial', :from => 'Tipo de bem'
      fill_modal 'Categoria', :with => 'Geral', :field => 'Descrição'
      fill_modal 'Contrato de dívida', :with => '2012', :field => 'Ano do contrato'
      fill_modal 'Fornecedor', :with => 'Wenderson Malheiros'
    end

    click_button 'Salvar'

    within_records do
      click_link '1 - Detran/2012'
    end

    within_tab 'Principal' do
      expect(page).to have_disabled_field 'Código'
      expect(page).to have_field 'Código', :with => '1'
    end
  end

  scenario 'validating javascript to item modal' do
    Material.make!(:arame_farpado)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Itens' do
      click_button "Adicionar Item"

      expect(page).to have_disabled_field "Unidade"

      fill_modal 'Item', :with => "Arame farpado", :field => "Descrição"

      expect(page).to have_field 'Unidade', :with => 'UN'

      fill_in 'Item', :with => ''

      expect(page).to have_field 'Unidade', :with => ''
    end
  end

  scenario 'expense_nature shuold be disabed if does not have a budget_allocation selected' do
    BudgetAllocation.make!(:alocacao)
    ReserveFund.make!(:detran_2012)

    navigate 'Contabilidade > Execução > Empenho > Empenhos'

    click_link 'Criar Empenho'

    within_tab 'Principal' do
      expect(page).to have_field 'Dotação', :with => ''
      expect(page).to have_disabled_field 'Desdobramento'

      fill_modal 'Reserva de dotação', :with => '22/02/2012', :field => 'Data'

      expect(page).to have_field 'Dotação', :with => '1 - Alocação'
      expect(page).to_not have_disabled_field 'Desdobramento'

      clear_modal 'Dotação'

      expect(page).to have_disabled_field 'Desdobramento'

      fill_modal 'Dotação', :with => '1', :field => 'Código'

      expect(page).to_not have_disabled_field 'Desdobramento'
    end
  end
end
