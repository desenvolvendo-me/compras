# encoding: utf-8
require 'spec_helper'

feature "CommunicationSources" do
  background do
    sign_in
  end

  scenario 'create a new communication_source' do
    navigate 'Comum > Legislação > Tipos do Meio de Divulgação'

    click_link 'Criar Tipo do Meio de Divulgação'

    fill_in 'Descrição', :with => 'Jornal de Circulação Municipal'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo do Meio de Divulgação criada com sucesso.'

    click_link 'Jornal de Circulação Municipal'

    expect(page).to have_field 'Descrição', :with => 'Jornal de Circulação Municipal'
  end

  scenario 'update an existent communication_source' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Comum > Legislação > Tipos do Meio de Divulgação'

    click_link 'Jornal de Circulação Municipal'

    fill_in 'Descrição', :with => 'Revista de Circulação Municipal'

    click_button 'Salvar'

    expect(page).to have_notice 'Tipo do Meio de Divulgação editada com sucesso.'

    click_link 'Revista de Circulação Municipal'

    expect(page).to have_field 'Descrição', :with => 'Revista de Circulação Municipal'
  end

  scenario 'destroy an existent communication_source' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Comum > Legislação > Tipos do Meio de Divulgação'

    click_link 'Jornal de Circulação Municipal'

    click_link 'Apagar'

    expect(page).to have_notice 'Tipo do Meio de Divulgação apagada com sucesso.'

    expect(page).to_not have_content 'Jornal de Circulação Municipal'
  end

  scenario 'index with columns at the index' do
    CommunicationSource.make!(:jornal_municipal)

    navigate 'Comum > Legislação > Tipos do Meio de Divulgação'

    within_records do
      expect(page).to have_content 'Descrição'

      within 'tbody tr' do
        expect(page).to have_content 'Jornal de Circulação Municipal'
      end
    end
  end
end
