# encoding: utf-8
require 'spec_helper'

feature "ExtraCredits" do
  background do
    sign_in
  end

  scenario 'create a new extra_credit' do
    Descriptor.make!(:detran_2012)
    RegulatoryAct.make!(:sopa)
    ExtraCreditNature.make!(:abre_credito)
    MovimentType.make!(:adicionar_dotacao)
    MovimentType.make!(:subtrair_do_excesso_arrecadado)
    budget_allocation = BudgetAllocation.make!(:alocacao)
    Capability.make!(:reforma)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      select 'Especial', :from => 'Tipo de crédito'
      fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar', :field => 'Descrição'
      fill_in 'Data crédito', :with => '01/03/2012'
    end

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_in 'Valor', :with => '10,00'
      end

      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
        fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
        fill_in 'Valor', :with => '10,00'
      end

      expect(page).to have_disabled_field 'Suplementado'
      expect(page).to have_field 'Suplementado', :with => '10,00'

      expect(page).to have_disabled_field 'Reduzido'
      expect(page).to have_field 'Reduzido', :with => '10,00'

      expect(page).to have_disabled_field 'Diferença'
      expect(page).to have_field 'Diferença', :with => '0,00'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Crédito Suplementar criado com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2012 - Detran'
      expect(page).to have_select 'Tipo de crédito', :selected => 'Especial'
      expect(page).to have_field 'Ato regulamentador', :with => 'Lei 1234'
      expect(page).to have_field 'Tipo de ato regulamentador', :with => 'Lei'
      expect(page).to have_field 'Data de publicação', :with => '02/01/2012'
      expect(page).to have_field 'Natureza de crédito', :with => 'Abre crédito suplementar'
      expect(page).to have_field 'Classificação da natureza de crédito', :with => 'Outros'
      expect(page).to have_field 'Data crédito', :with => '01/03/2012'
    end

    within_tab 'Movimentos' do
      within 'fieldset:last' do
        expect(page).to have_field 'Tipo de movimento', :with => 'Adicionar dotação'
        expect(page).to have_field 'Dotação', :with => budget_allocation.to_s
        expect(page).to have_disabled_field 'Recurso'
        expect(page).to have_field 'Valor', :with => '10,00'
      end

      within 'fieldset:first' do
        expect(page).to have_field 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
        expect(page).to have_disabled_field 'Dotação'
        expect(page).to have_field 'Recurso', :with => 'Reforma e Ampliação'
        expect(page).to have_field 'Valor', :with => '10,00'
      end

      expect(page).to have_disabled_field 'Suplementado'
      expect(page).to have_field 'Suplementado', :with => '10,00'

      expect(page).to have_disabled_field 'Reduzido'
      expect(page).to have_field 'Reduzido', :with => '10,00'

      expect(page).to have_disabled_field 'Diferença'
      expect(page).to have_field 'Diferença', :with => '0,00'
    end
  end

  scenario 'calculate suplement and reduced' do
    MovimentType.make!(:adicionar_dotacao)
    MovimentType.make!(:subtrair_do_excesso_arrecadado)
    BudgetAllocation.make!(:alocacao)
    Capability.make!(:reforma)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'

        ignoring_scopes do
          # bugfix: avoid NaN error
          expect(page).to have_field 'Suplementado', :with => '0,00'
          expect(page).to have_field 'Diferença', :with => '0,00'
        end

        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_in 'Valor', :with => '10,00'
      end

      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'

        ignoring_scopes do
          # bugfix: avoid NaN error
          expect(page).to have_field 'Reduzido', :with => '0,00'
          expect(page).to have_field 'Diferença', :with => '10,00'
        end

        fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
        fill_in 'Valor', :with => '10,00'
      end

      expect(page).to have_disabled_field 'Suplementado'
      expect(page).to have_field 'Suplementado', :with => '10,00'

      expect(page).to have_disabled_field 'Reduzido'
      expect(page).to have_field 'Reduzido', :with => '10,00'

      expect(page).to have_disabled_field 'Diferença'
      expect(page).to have_field 'Diferença', :with => '0,00'
    end
  end

  scenario 'when operation is subtraction and budget_allocation used item value should not be greater than budget allocation real_amount' do
    MovimentType.make!(:subtrair_dotacao)
    MovimentType.make!(:adicionar_em_outros_casos)
    BudgetAllocation.make!(:alocacao)
    Capability.make!(:reforma)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair dotação'
        fill_modal 'Dotação', :with => '1', :field => 'Código'
        fill_in 'Valor', :with => '501,00'
      end

      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar em outros casos'
        fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
        fill_in 'Valor', :with => '10,00'
      end
    end

    click_button 'Salvar'

    within_tab 'Movimentos' do
      expect(page).to have_content 'não pode ser maior que o saldo real da dotação (R$ 489,50)'
    end
  end

  scenario 'when fill administractive act should fill regulatory_act_type and publication_date too' do
    RegulatoryAct.make!(:sopa)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    expect(page).to have_field 'Tipo de ato regulamentador', :with => 'Lei'
    expect(page).to have_field 'Data de publicação', :with => '02/01/2012'
  end

  scenario 'when fill additional credit opening should fill kind too' do
    ExtraCreditNature.make!(:abre_credito)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar', :field => 'Descrição'

    expect(page).to have_field 'Classificação da natureza de crédito', :with => 'Outros'
  end

  context 'should have modal link' do
    scenario 'when already stored' do
      extra_credit = ExtraCredit.make!(:detran_2012)

      navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link "#{extra_credit.id}"

      within_tab 'Movimentos' do
        within 'fieldset:first' do
          click_link 'Mais informações'
        end
      end

      expect(page).to have_content 'Informações de: 1 - Alocação'
    end

    scenario 'when change budget_allocation' do
      extra_credit = ExtraCredit.make!(:detran_2012)
      BudgetAllocation.make!(:alocacao_extra)

      navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link extra_credit.to_s

      within_tab 'Movimentos' do
        within 'fieldset:first' do
          click_link 'Mais informações'
        end
      end

      expect(page).to have_content 'Informações de: 1 - Alocação'
    end

    scenario 'when add a new record' do
      MovimentType.make!(:adicionar_dotacao)
      BudgetAllocation.make!(:alocacao_extra)

      navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link 'Criar Crédito Suplementar'

      within_tab 'Movimentos' do
        click_button 'Adicionar Movimento'

        within 'fieldset:first' do
          fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'
          fill_modal 'Dotação', :with => '1', :field => 'Código'

          click_link 'Mais informações'
        end
      end

      expect(page).to have_content 'Informações de: 1 - Alocação extra'
    end
  end

  context 'should have modal link to capability' do
    scenario 'when already stored' do
      extra_credit = ExtraCredit.make!(:detran_2012)

      navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link extra_credit.to_s

      within_tab 'Movimentos' do
        within 'fieldset:last' do
          within '.capability-field' do
            click_link 'Mais informações'
          end
        end
      end

      expect(page).to have_content 'Informações de: Reforma e Ampliação'
    end

    scenario 'when change' do
      extra_credit = ExtraCredit.make!(:detran_2012)
      Capability.make!(:construcao)

      navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link extra_credit.to_s

      within_tab 'Movimentos' do
        within 'fieldset:last' do
          fill_modal 'Recurso', :with => 'Construção', :field => 'Descrição'

          within '.capability-field' do
            click_link 'Mais informações'
          end
        end
      end

      expect(page).to have_content 'Informações de: Construção'
    end

    scenario 'when add a new record' do
      MovimentType.make!(:subtrair_do_excesso_arrecadado)
      Capability.make!(:construcao)

      navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

      click_link 'Criar Crédito Suplementar'

      within_tab 'Movimentos' do
        click_button 'Adicionar Movimento'

        within 'fieldset:first' do
          fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
          fill_modal 'Recurso', :with => 'Construção', :field => 'Descrição'

          within '.capability-field' do
            click_link 'Mais informações'
          end
        end
      end

      expect(page).to have_content 'Informações de: Construção'
    end
  end

  scenario 'remove extra_credit_moviment_type' do
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    within_tab 'Movimentos' do
      click_button 'Remover Movimento'
      click_button 'Remover Movimento'
    end

    click_button 'Salvar'

    click_link extra_credit.to_s

    within_tab 'Movimentos' do
      expect(page).to_not have_field 'Tipo de movimento'
      expect(page).to_not have_field 'Dotação'
      expect(page).to_not have_field 'Recurso'
      expect(page).to_not have_field 'Valor'
    end
  end

  scenario 'update an existent extra_credit' do
    Descriptor.make!(:secretaria_de_educacao_2011)
    RegulatoryAct.make!(:emenda)
    extra_credit = ExtraCredit.make!(:detran_2012)
    ExtraCreditNature.make!(:abre_credito_de_transferencia)
    MovimentType.make!(:subtrair_do_excesso_arrecadado)
    Capability.make!(:reforma)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    within_tab 'Principal' do
      fill_modal 'Descritor', :with => '2011', :field => 'Exercício'
      fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
      select 'Suplementar', :from => 'Tipo de crédito'
      fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar de transferência', :field => 'Descrição'
      fill_in 'Data crédito', :with => '21/03/2012'
    end

    within_tab 'Movimentos' do
      within 'fieldset:first' do
        fill_in 'Valor', :with => '20,00'
      end

      within 'fieldset:last' do
        fill_in 'Valor', :with => '20,00'
      end
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Crédito Suplementar editado com sucesso.'

    click_link extra_credit.to_s

    within_tab 'Principal' do
      expect(page).to have_field 'Descritor', :with => '2011 - Secretaria de Educação'
      expect(page).to have_select 'Tipo de crédito', :selected => 'Suplementar'
      expect(page).to have_field 'Ato regulamentador', :with => 'Emenda constitucional 4567'
      expect(page).to have_field 'Tipo de ato regulamentador', :with => 'Emenda constitucional'
      expect(page).to have_field 'Natureza de crédito', :with => 'Abre crédito suplementar de transferência'
      expect(page).to have_field 'Classificação da natureza de crédito', :with => 'Transferência'
      expect(page).to have_field 'Data de publicação', :with => '02/01/2012'
      expect(page).to have_field 'Data crédito', :with => '21/03/2012'
    end

    within_tab 'Movimentos' do
      within 'fieldset:first' do
        expect(page).to have_field 'Valor', :with => '20,00'
      end

      within 'fieldset:first' do
        expect(page).to have_field 'Valor', :with => '20,00'
      end
    end
  end

  scenario 'validate uniqueness of budget_allocation' do
    BudgetAllocation.make!(:alocacao)
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:last' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'
        fill_modal 'Dotação', :with => '1', :field => 'Código'
      end
    end

    click_button 'Salvar'

    within_tab 'Movimentos' do
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'validate uniqueness of capibality' do
    BudgetAllocation.make!(:alocacao)
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:first' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
        fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      end
    end

    click_button 'Salvar'

    within_tab 'Movimentos' do
      expect(page).to have_content 'já está em uso'
    end
  end

  scenario 'validate uniqueness of administractive act' do
    ExtraCredit.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Criar Crédito Suplementar'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    click_button 'Salvar'

    expect(page).to have_content 'já utilizado em outro crédito suplementar'
  end

  scenario 'destroy an existent extra_credit' do
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link extra_credit.to_s

    click_link "Apagar"

    expect(page).to have_notice 'Crédito Suplementar apagado com sucesso.'

    expect(page).to_not have_content 'Detran'
    expect(page).to_not have_content '2012'
    expect(page).to_not have_content 'Especial'
  end

  scenario 'access modal' do
    extra_credit = ExtraCredit.make!(:detran_2012)

    navigate 'Contabilidade > Orçamento > Crédito Suplementar > Créditos Suplementares'

    click_link 'Filtrar Créditos Suplementares'

    select 'Suplementar', :from => 'Tipo de crédito'

    click_button 'Pesquisar'

    within_records do
      expect(page).to_not have_css('a')
    end
  end
end
