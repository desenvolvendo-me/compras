# encoding: utf-8
require 'spec_helper'

feature "AdditionalCreditOpenings" do
  background do
    sign_in
  end

  scenario 'create a new additional_credit_opening' do
    Entity.make!(:detran)
    AdministractiveAct.make!(:sopa)
    AdditionalCreditOpeningNature.make!(:abre_credito)
    MovimentType.make!(:adicionar_dotacao)
    budget_allocation = BudgetAllocation.make!(:alocacao)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link 'Criar Abertura de Crédito Suplementar'

    within_tab 'Principal' do
      fill_modal 'Entidade', :with => 'Detran'
      fill_in 'Exercício', :with => 2012
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      select 'Especial', :from => 'Tipo de crédito'
      fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar', :field => 'Descrição'
      fill_in 'Data crédito', :with => '01/03/2012'
    end

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'
      fill_modal 'Dotação', :with => '2012', :field => 'Exercício'
      fill_in 'Valor', :with => '10,00'
    end

    click_button 'Criar Abertura de Crédito Suplementar'

    page.should have_notice 'Abertura de Crédito Suplementar criado com sucesso.'

    click_link '2012'

    within_tab 'Principal' do
      page.should have_field 'Entidade', :with => 'Detran'
      page.should have_field 'Exercício', :with => '2012'
      page.should have_select 'Tipo de crédito', :selected => 'Especial'
      page.should have_field 'Ato regulamentador', :with => '1234'
      page.should have_field 'Tipo de ato regulamentador', :with => 'Lei'
      page.should have_field 'Data de publicação', :with => '02/01/2012'
      page.should have_field 'Natureza de crédito', :with => 'Abre crédito suplementar'
      page.should have_field 'Classificação da natureza de crédito', :with => 'Outros'
      page.should have_field 'Data crédito', :with => '01/03/2012'
    end

    within_tab 'Movimentos' do
      page.should have_field 'Tipo de movimento', :with => 'Adicionar dotação'
      page.should have_field 'Dotação', :with => "#{budget_allocation.id}/2012 - Alocação"
      page.should have_disabled_field 'Recurso'
      page.should have_field 'Valor', :with => '10,00'
    end
  end

  scenario 'when fill administractive act should fill administractive_act_type and publication_date too' do
    AdministractiveAct.make!(:sopa)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link 'Criar Abertura de Crédito Suplementar'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    page.should have_field 'Tipo de ato regulamentador', :with => 'Lei'
    page.should have_field 'Data de publicação', :with => '02/01/2012'
  end

  scenario 'when fill additional credit opening should fill kind too' do
    AdditionalCreditOpeningNature.make!(:abre_credito)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link 'Criar Abertura de Crédito Suplementar'

    fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar', :field => 'Descrição'

    page.should have_field 'Classificação da natureza de crédito', :with => 'Outros'
  end

  scenario 'remove additional_credit_opening_moviment_type' do
    AdditionalCreditOpening.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link '2012'

    within_tab 'Movimentos' do
      click_button 'Remover Movimento'
    end

    click_button 'Atualizar Abertura de Crédito Suplementar'

    click_link '2012'

    within_tab 'Movimentos' do
      page.should_not have_field 'Tipo de movimento'
      page.should_not have_field 'Dotação'
      page.should_not have_field 'Recurso'
      page.should_not have_field 'Valor'
    end
  end

  scenario 'update an existent additional_credit_opening' do
    Entity.make!(:secretaria_de_educacao)
    AdministractiveAct.make!(:emenda)
    AdditionalCreditOpening.make!(:detran_2012)
    AdditionalCreditOpeningNature.make!(:abre_credito_de_transferencia)
    MovimentType.make!(:subtrair_do_excesso_arrecadado)
    Capability.make!(:reforma)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link '2012'

    within_tab 'Principal' do
      fill_modal 'Entidade', :with => 'Secretaria de Educação'
      fill_in 'Exercício', :with => 2011
      fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
      select 'Suplementar', :from => 'Tipo de crédito'
      fill_modal 'Natureza de crédito', :with => 'Abre crédito suplementar de transferência', :field => 'Descrição'
      fill_in 'Data crédito', :with => '21/03/2012'
    end

    within_tab 'Movimentos' do
      click_button 'Remover Movimento'
      click_button 'Adicionar Movimento'

      fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
      fill_modal 'Recurso', :with => 'Reforma e Ampliação', :field => 'Descrição'
      fill_in 'Valor', :with => '20,00'
    end

    click_button 'Atualizar Abertura de Crédito Suplementar'

    page.should have_notice 'Abertura de Crédito Suplementar editado com sucesso.'

    click_link '2011'

    within_tab 'Principal' do
      page.should have_field 'Entidade', :with => 'Secretaria de Educação'
      page.should have_field 'Exercício', :with => '2011'
      page.should have_select 'Tipo de crédito', :selected => 'Suplementar'
      page.should have_field 'Ato regulamentador', :with => '4567'
      page.should have_field 'Tipo de ato regulamentador', :with => 'Emenda constitucional'
      page.should have_field 'Natureza de crédito', :with => 'Abre crédito suplementar de transferência'
      page.should have_field 'Classificação da natureza de crédito', :with => 'Transferência'
      page.should have_field 'Data de publicação', :with => '02/01/2012'
      page.should have_field 'Data crédito', :with => '21/03/2012'
    end

    within_tab 'Movimentos' do
      page.should have_field 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
      page.should have_disabled_field 'Dotação'
      page.should have_field 'Recurso', :with => 'Reforma e Ampliação'
      page.should have_field 'Valor', :with => '20,00'
    end
  end

  scenario 'validate uniqueness of budget_allocation' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    AdditionalCreditOpening.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link '2012'

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:last' do
        fill_modal 'Tipo de movimento', :with => 'Adicionar dotação'
        fill_modal 'Dotação', :with => '2012', :field => 'Exercício'
      end
    end

    click_button 'Atualizar Abertura de Crédito Suplementar'

    within_tab 'Movimentos' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'validate uniqueness of capibality' do
    budget_allocation = BudgetAllocation.make!(:alocacao)
    AdditionalCreditOpening.make!(:detran_2012_com_recurso)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link '2012'

    within_tab 'Movimentos' do
      click_button 'Adicionar Movimento'

      within 'fieldset:last' do
        fill_modal 'Tipo de movimento', :with => 'Subtrair do excesso arrecadado'
        fill_modal 'Recurso', :with => '2012', :field => 'Exercício'
      end
    end

    click_button 'Atualizar Abertura de Crédito Suplementar'

    within_tab 'Movimentos' do
      page.should have_content 'já está em uso'
    end
  end

  scenario 'validate uniqueness of administractive act' do
    AdditionalCreditOpening.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link 'Criar Abertura de Crédito Suplementar'

    fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

    click_button 'Criar Abertura de Crédito Suplementar'

    page.should have_content 'já utilizado em outra abertura de crédito suplementar'
  end

  scenario 'destroy an existent additional_credit_opening' do
    AdditionalCreditOpening.make!(:detran_2012)

    click_link 'Contabilidade'

    click_link 'Aberturas de Créditos Suplementares'

    click_link '2012'

    click_link 'Apagar 2012', :confirm => true

    page.should have_notice 'Abertura de Crédito Suplementar apagado com sucesso.'

    page.should_not have_content 'Detran'
    page.should_not have_content '2012'
    page.should_not have_content 'Especial'
  end
end
