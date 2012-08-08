# encoding: utf-8
require 'spec_helper'

feature "CommunicationSources" do
  background do
    sign_in
  end

  scenario 'create a new communication_source' do
    navigate 'Compras e Licitações > Cadastros Gerais > Fontes de Comunicação'

    click_link 'Criar Fonte de Comunicação'

    fill_in 'Descrição', :with => 'Jornal de Circulação Municipal'

    click_button 'Salvar'

    expect(page).to have_notice 'Fonte de Comunicação criado com sucesso.'

    click_link 'Jornal de Circulação Municipal'

    expect(page).to have_field 'Descrição', :with => 'Jornal de Circulação Municipal'
  end

  scenario 'validates uniqueness of description' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Compras e Licitações > Cadastros Gerais > Fontes de Comunicação'

    click_link 'Criar Fonte de Comunicação'

    fill_in 'Descrição', :with => 'Jornal de Circulação Municipal'

    click_button 'Salvar'

    expect(page).not_to have_notice 'Fonte de Comunicação criado com sucesso.'

    expect(page).to have_content 'já está em uso'
  end

  scenario 'update an existent communication_source' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Compras e Licitações > Cadastros Gerais > Fontes de Comunicação'

    click_link 'Jornal de Circulação Municipal'

    fill_in 'Descrição', :with => 'Revista de Circulação Municipal'

    click_button 'Salvar'

    expect(page).to have_notice 'Fonte de Comunicação editado com sucesso.'

    click_link 'Revista de Circulação Municipal'

    expect(page).to have_field 'Descrição', :with => 'Revista de Circulação Municipal'
  end

  scenario 'destroy an existent communication_source' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Compras e Licitações > Cadastros Gerais > Fontes de Comunicação'

    click_link 'Jornal de Circulação Municipal'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Fonte de Comunicação apagado com sucesso.'

    expect(page).not_to have_content 'Jornal de Circulação Municipal'
  end
end
