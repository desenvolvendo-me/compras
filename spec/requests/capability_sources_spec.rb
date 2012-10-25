# encoding: utf-8
require 'spec_helper'

feature "CapabilitySources" do
  background do
    sign_in
  end

  scenario 'create a new capability_source' do
    navigate 'Outros > Contabilidade > Orçamento > Recurso > Fontes de Recursos'

    click_link 'Criar Fonte de Recursos'

    fill_in 'Código', :with => '1'
    fill_in 'Nome', :with => 'Imposto'
    fill_in 'Especificação', :with => 'Imposto específico'
    expect(page).to have_disabled_field 'Fonte'
    expect(page).to have_select 'Fonte', :selected => 'Manual'

    click_button 'Salvar'

    expect(page).to have_notice 'Fonte de Recursos criada com sucesso.'

    click_link 'Imposto'

    expect(page).to have_field 'Código', :with => '1'
    expect(page).to have_field 'Nome', :with => 'Imposto'
    expect(page).to have_field 'Especificação', :with => 'Imposto específico'
    expect(page).to have_disabled_field 'Fonte'
    expect(page).to have_select 'Fonte', :selected => 'Manual'
  end

  scenario 'create capability_source with existent code' do
    CapabilitySource.make!(:imposto)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Fontes de Recursos'

    click_link 'Criar Fonte de Recursos'

    fill_in 'Código', :with => '1'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end

  scenario 'update an existent capability_source' do
    CapabilitySource.make!(:imposto)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Fontes de Recursos'

    click_link 'Imposto'

    fill_in 'Código', :with => '1'
    fill_in 'Nome', :with => 'Impostos'
    fill_in 'Especificação', :with => 'specification'
    expect(page).to have_disabled_field 'Fonte'
    expect(page).to have_select 'Fonte', :selected => 'Manual'

    click_button 'Salvar'

    expect(page).to have_notice 'Fonte de Recursos editada com sucesso.'

    click_link 'Impostos'

    expect(page).to have_field 'Código', :with => '1'
    expect(page).to have_field 'Nome', :with => 'Impostos'
    expect(page).to have_field 'Especificação', :with => 'specification'
    expect(page).to have_disabled_field 'Fonte'
    expect(page).to have_select 'Fonte', :selected => 'Manual'
  end

  scenario 'destroy an existent capability_source' do
    CapabilitySource.make!(:imposto)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Fontes de Recursos'

    click_link 'Imposto'

    click_link 'Apagar'

    expect(page).to have_notice 'Fonte de Recursos apagada com sucesso.'

    expect(page).to_not have_content 'Imposto'
  end
end
