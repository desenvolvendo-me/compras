# encoding:utf-8
require 'spec_helper'

feature "Condominia" do
  background do
    sign_in
  end

  scenario 'create a new condominium' do
    Neighborhood.make!(:sao_francisco)
    Street.make!(:girassol)

    navigate 'Geral > Parâmetros > Endereços > Condomínios'

    click_link 'Criar Condomínio'

    fill_in 'Nome', :with => 'Tambuata'
    select 'Vertical', :from => 'Tipo de condomínio'

    click_button 'Salvar'

    expect(page).to have_notice 'Condomínio criado com sucesso.'

    click_link 'Tambuata'

    expect(page).to have_field 'Nome', :with => 'Tambuata'
    expect(page).to have_select 'Tipo de condomínio', :selected => 'Vertical'
  end

  scenario 'update a condominium' do
    Condominium.make!(:tambuata)

    navigate 'Geral > Parâmetros > Endereços > Condomínios'

    click_link 'Tambuata'

    fill_in 'Nome', :with => 'Parque das Flores'

    click_button 'Salvar'

    expect(page).to have_notice 'Condomínio editado com sucesso.'

    click_link 'Parque das Flores'

    expect(page).to have_field 'Nome', :with => 'Parque das Flores'
  end

  scenario 'destroy a condominium' do
    Condominium.make!(:tambuata)

    navigate 'Geral > Parâmetros > Endereços > Condomínios'

    click_link 'Tambuata'

    click_link 'Apagar'

    expect(page).to have_notice 'Condomínio apagado com sucesso.'

    expect(page).to_not have_content 'Tambuata'
  end

  scenario 'index with columns at the index' do
    Condominium.make!(:tambuata)

    navigate 'Geral > Parâmetros > Endereços > Condomínios'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Tipo de condomínio'

      within 'tbody tr' do
        expect(page).to have_content 'Tambuata'
        expect(page).to have_content 'Vertical'
      end
    end
  end
end
