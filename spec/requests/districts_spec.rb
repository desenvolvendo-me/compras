# encoding: utf-8
require 'spec_helper'

feature "Districts" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new district' do
    navigate 'Geral > Parâmetros > Endereços > Distritos'

    click_link 'Criar Distrito'

    fill_in 'Nome', :with => 'Leste'
    fill_modal 'Cidade', :with => "Belo Horizonte"

    click_button 'Salvar'

    expect(page).to have_notice 'Distrito criado com sucesso.'

    click_link 'Leste'

    expect(page).to have_field 'Nome', :with => 'Leste'
    expect(page).to have_field 'Cidade', :with => 'Porto Alegre'

    fill_in 'Nome', :with => 'Sul'

    click_button 'Salvar'

    expect(page).to have_notice 'Distrito editado com sucesso.'

    click_link 'Sul'

    expect(page).to have_field 'Nome', :with => 'Sul'

    click_link 'Apagar'

    expect(page).to have_notice 'Distrito apagado com sucesso.'

    expect(page).to_not have_content 'Sul'
  end

  scenario 'index with columns at the index' do
    navigate 'Geral > Parâmetros > Endereços > Distritos'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Cidade'

      within 'tbody tr' do
        expect(page).to have_content 'Leste'
        expect(page).to have_content 'Porto Alegre'
      end
    end
  end
end
