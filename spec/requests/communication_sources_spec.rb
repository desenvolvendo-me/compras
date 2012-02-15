# encoding: utf-8
require 'spec_helper'

feature "CommunicationSources" do
  background do
    sign_in
  end

  scenario 'create a new communication_source' do
    click_link 'Solicitações'

    click_link 'Fontes de Comunicação'

    click_link 'Criar Fonte de Comunicação'

    fill_in 'Descrição', :with => 'Jornal de Circulação Municipal'

    click_button 'Criar Fonte de Comunicação'

    page.should have_notice 'Fonte de Comunicação criado com sucesso.'

    click_link 'Jornal de Circulação Municipal'

    page.should have_field 'Descrição', :with => 'Jornal de Circulação Municipal'
  end

  scenario 'validates uniqueness of description' do
    CommunicationSource.make!(:jornal_municipal)

    click_link 'Solicitações'

    click_link 'Fontes de Comunicação'

    click_link 'Criar Fonte de Comunicação'

    fill_in 'Descrição', :with => 'Jornal de Circulação Municipal'

    click_button 'Criar Fonte de Comunicação'

    page.should_not have_notice 'Fonte de Comunicação criado com sucesso.'

    page.should have_content 'já está em uso'
  end

  scenario 'update an existent communication_source' do
    CommunicationSource.make!(:jornal_municipal)

    click_link 'Solicitações'

    click_link 'Fontes de Comunicação'

    click_link 'Jornal de Circulação Municipal'

    fill_in 'Descrição', :with => 'Revista de Circulação Municipal'

    click_button 'Atualizar Fonte de Comunicação'

    page.should have_notice 'Fonte de Comunicação editado com sucesso.'

    click_link 'Revista de Circulação Municipal'

    page.should have_field 'Descrição', :with => 'Revista de Circulação Municipal'
  end

  scenario 'destroy an existent communication_source' do
    CommunicationSource.make!(:jornal_municipal)

    click_link 'Solicitações'

    click_link 'Fontes de Comunicação'

    click_link 'Jornal de Circulação Municipal'

    click_link 'Apagar Jornal de Circulação Municipal', :confirm => true

    page.should have_notice 'Fonte de Comunicação apagado com sucesso.'

    page.should_not have_content 'Jornal de Circulação Municipal'
  end
end
