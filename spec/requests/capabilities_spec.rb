# encoding: utf-8
require 'spec_helper'

feature "Capabilities" do
  background do
    sign_in
  end

  scenario 'create a new capability' do
    Descriptor.make!(:detran_2012)
    CapabilityDestination.make!(:linha_de_credito)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Recursos'

    click_link 'Criar Recurso'

    fill_modal 'Descritor', :with => '2012', :field => 'Ano do exercício'
    fill_in 'Descrição', :with => 'Reforma'
    fill_modal 'Destinação de recursos', :with => 'Programa de linha de crédito', :field => 'Descrição'
    fill_in 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios'
    select 'Ordinário', :from => 'Tipo'

    expect(page).to have_disabled_field 'Status'
    expect(page).to have_select 'Status', :selected => 'Ativo'

    click_button 'Salvar'

    expect(page).to have_notice 'Recurso criado com sucesso.'

    click_link 'Reforma'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Descrição', :with => 'Reforma'
    expect(page).to have_field 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios'
    expect(page).to have_field 'Destinação de recursos', :with => 'Programa de linha de crédito'
    expect(page).to have_select 'Tipo', :selected => 'Ordinário'
    expect(page).to have_select 'Status', :selected => 'Ativo'
  end

  scenario 'update an existent capability' do
    Capability.make!(:reforma)
    Descriptor.make!(:secretaria_de_educacao_2013)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Recursos'

    click_link 'Reforma e Ampliação'

    fill_modal 'Descritor', :with => '2013', :field => 'Ano do exercício'
    fill_in 'Descrição', :with => 'Reforma e Ampliação do Posto'
    fill_in 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios no posto'
    select 'Vinculado', :from => 'Tipo'
    select 'Inativo', :from => 'Status'

    click_button 'Salvar'

    expect(page).to have_notice 'Recurso editado com sucesso.'

    click_link 'Reforma e Ampliação do Posto'

    expect(page).to have_field 'Descritor', :with => '2013 - Secretaria de Educação'
    expect(page).to have_field 'Descrição', :with => 'Reforma e Ampliação do Posto'
    expect(page).to have_field 'Finalidade', :with => 'Otimizar o atendimento a todos os municípios no posto'
    expect(page).to have_select 'Tipo', :selected => 'Vinculado'
    expect(page).to have_select 'Status', :selected => 'Inativo'
  end

  scenario 'destroy an existent capability' do
    Capability.make!(:reforma)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Recursos'

    click_link 'Reforma e Ampliação'

    click_link 'Apagar'

    expect(page).to have_notice 'Recurso apagado com sucesso.'

    expect(page).to_not have_content 'Detran'
    expect(page).to_not have_content '2012'
    expect(page).to_not have_content 'Reforma e Ampliação'
    expect(page).to_not have_content 'Ordinário'
    expect(page).to_not have_content 'Ativo'
  end
end
