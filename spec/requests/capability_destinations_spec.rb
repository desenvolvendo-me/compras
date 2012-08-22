# encoding: utf-8
require 'spec_helper'

feature "CapabilityDestinations" do
  background do
    sign_in
  end

  scenario 'create a new capability_destination' do
    CapabilityAllocationDetail.make!(:educacao)

    navigate 'Contabilidade > Orçamento > Recurso > Destinações de Recursos'

    click_link 'Criar Destinação de Recursos'

    within_tab 'Principal' do
      select 'Contrapartida de doações', :from => 'Uso'
      select 'Recursos condicionais', :from => 'Grupo'
      fill_in 'Especificação', :with => '1'
      fill_in 'Descrição', :with => 'Programa de linha de crédito'
      select 'Primária', :from => 'Destinação *'
    end

    within_tab 'Detalhamento' do
      click_button 'Adicionar Detalhamento'

      fill_modal 'Detalhamento', :with => 'Educação', :field => 'Descrição'
      select 'Ativo', :from => 'Status'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Destinação de Recursos criado com sucesso.'

    click_link 'Programa de linha de crédito'

    within_tab 'Principal' do
      expect(page).to have_select 'Uso *', :selected => 'Contrapartida de doações'
      expect(page).to have_select 'Grupo', :selected => 'Recursos condicionais'
      expect(page).to have_field 'Especificação', :with => '1'
      expect(page).to have_field 'Descrição', :with => 'Programa de linha de crédito'
      expect(page).to have_select 'Destinação', :selected => 'Primária'
    end

    within_tab 'Detalhamento' do
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_field 'Detalhamento', :with => 'Educação'
    end
  end

  scenario 'update an existent capability_destination' do
    CapabilityDestination.make!(:linha_de_credito)

    navigate 'Contabilidade > Orçamento > Recurso > Destinações de Recursos'

    click_link 'Programa de linha de crédito'

    within_tab 'Principal' do
      select 'Contrapartida de outros empréstimos', :from => 'Uso'
      select 'Recursos do tesouro - exercício corrente', :from => 'Grupo'
      fill_in 'Especificação', :with => '2'
      fill_in 'Descrição', :with => 'Programa de linha de crédito para projetos'
      select 'Não primária', :from => 'Destinação *'
    end

    within_tab 'Detalhamento' do
      click_button 'Remover Detalhamento'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Destinação de Recursos editado com sucesso.'

    click_link 'Programa de linha de crédito para projetos'

    within_tab 'Principal' do
      expect(page).to have_select 'Uso *', :selected => 'Contrapartida de outros empréstimos'
      expect(page).to have_select 'Grupo', :selected => 'Recursos do tesouro - exercício corrente'
      expect(page).to have_field 'Especificação', :with => '2'
      expect(page).to have_field 'Descrição', :with => 'Programa de linha de crédito para projetos'
      expect(page).to have_select 'Destinação', :selected => 'Não primária'
    end

    within_tab 'Detalhamento' do
      expect(page).to_not have_field 'Detalhamento', :with => 'Educação'
    end
  end

  scenario 'destroy an existent capability_destination' do
    CapabilityDestination.make!(:linha_de_credito)

    navigate 'Contabilidade > Orçamento > Recurso > Destinações de Recursos'

    click_link 'Programa de linha de crédito'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Destinação de Recursos apagado com sucesso.'

    expect(page).to_not have_content 'Programa de linha de crédito'
  end
end
