# encoding: utf-8
require 'spec_helper'

feature "DisseminationSources" do
  background do
    sign_in
  end

  scenario 'create a new dissemination_source' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Cadastros Gerais > Legislação > Fontes de Divulgação'

    click_link 'Criar Fonte de Divulgação'

    fill_in 'Descrição', :with => 'Jornal Oficial do Município'
    fill_modal 'Fonte de comunicação', :with => 'Jornal de Circulação Municipal', :field => 'Descrição'

    click_button 'Salvar'

    expect(page).to have_notice 'Fonte de Divulgação criada com sucesso.'

    click_link 'Jornal Oficial do Município'

    expect(page).to have_field 'Descrição', :with => 'Jornal Oficial do Município'
    expect(page).to have_field 'Fonte de comunicação', :with => 'Jornal de Circulação Municipal'
  end

  scenario 'update an existent dissemination_source' do
    DisseminationSource.make!(:jornal_municipal)
    CommunicationSource.make!(:jornal_estadual)

    navigate 'Cadastros Gerais > Legislação > Fontes de Divulgação'

    click_link 'Jornal Oficial do Município'

    fill_in 'Descrição', :with => 'Jornal Não Oficial do Município'

    fill_modal 'Fonte de comunicação', :with => 'Jornal de Circulação Estadual', :field => 'Descrição'

    click_button 'Salvar'

    expect(page).to have_notice 'Fonte de Divulgação editada com sucesso.'

    click_link 'Jornal Não Oficial do Município'

    expect(page).to have_field 'Descrição', :with => 'Jornal Não Oficial do Município'

    expect(page).to have_field 'Fonte de comunicação', :with => 'Jornal de Circulação Estadual'
  end

  scenario 'destroy an existent dissemination_source' do
    DisseminationSource.make!(:jornal_municipal)

    navigate 'Cadastros Gerais > Legislação > Fontes de Divulgação'

    click_link 'Jornal Oficial do Município'

    click_link 'Apagar'

    expect(page).to have_notice 'Fonte de Divulgação apagada com sucesso.'

    expect(page).to_not have_content 'Jornal Oficial do Município'
    expect(page).to_not have_content 'Jornal de Circulação Municipal'
  end

  scenario 'cannot destroy an existent dissemination_source with regulatory_act relationship' do
    RegulatoryAct.make!(:sopa)

    navigate 'Cadastros Gerais > Legislação > Fontes de Divulgação'

    click_link 'Jornal Oficial do Bairro'

    click_link 'Apagar'

    expect(page).to_not have_notice 'Fonte de Divulgação apagada com sucesso.'

    expect(page).to have_alert 'Fonte de Divulgação não pode ser apagada.'
  end
end
