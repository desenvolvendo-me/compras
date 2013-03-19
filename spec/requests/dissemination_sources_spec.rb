# encoding: utf-8
require 'spec_helper'

feature "DisseminationSources" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new dissemination_source' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Comum > Legislação > Meios de Divulgação'

    click_link 'Criar Meio de Divulgação'

    fill_in 'Descrição', :with => 'Jornal Oficial do Município'
    fill_modal 'Tipo do meio de divulgação', :with => 'Jornal de Circulação Municipal', :field => 'Descrição'

    click_button 'Salvar'

    expect(page).to have_notice 'Meio de Divulgação criada com sucesso.'

    click_link 'Jornal Oficial do Município'

    expect(page).to have_field 'Descrição', :with => 'Jornal Oficial do Município'
    expect(page).to have_field 'Tipo do meio de divulgação', :with => 'Jornal de Circulação Municipal'

    fill_in 'Descrição', :with => 'Jornal Não Oficial do Município'
    fill_modal 'Tipo do meio de divulgação', :with => 'Jornal de Circulação Municipal', :field => 'Descrição'

    click_button 'Salvar'

    expect(page).to have_notice 'Meio de Divulgação editada com sucesso.'

    click_link 'Jornal Não Oficial do Município'

    expect(page).to have_field 'Descrição', :with => 'Jornal Não Oficial do Município'

    expect(page).to have_field 'Tipo do meio de divulgação', :with => 'Jornal de Circulação Municipal'

    click_link 'Apagar'

    expect(page).to have_notice 'Meio de Divulgação apagada com sucesso.'

    expect(page).to_not have_content 'Jornal Oficial do Município'
    expect(page).to_not have_content 'Jornal de Circulação Municipal'
  end

  scenario 'cannot destroy an existent dissemination_source with regulatory_act relationship' do
    RegulatoryAct.make!(:sopa)

    navigate 'Comum > Legislação > Meios de Divulgação'

    click_link 'Jornal Oficial do Bairro'

    click_link 'Apagar'

    expect(page).to_not have_notice 'Meio de Divulgação apagada com sucesso.'

    expect(page).to have_alert 'Meio de Divulgação não pode ser apagada.'
  end

  scenario 'index with columns at the index' do
    DisseminationSource.make!(:jornal_municipal)

    navigate 'Comum > Legislação > Meios de Divulgação'

    within_records do
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Tipo do meio de divulgação'

      within 'tbody tr' do
        expect(page).to have_content 'Jornal Oficial do Município'
        expect(page).to have_content 'Jornal de Circulação Municipal'
      end
    end
  end
end
