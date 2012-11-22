# encoding: utf-8
require 'spec_helper'

feature "States" do
  background do
    sign_in
  end

  scenario 'cannot create a new state' do
    navigate 'Geral > Parâmetros > Endereços > Estados'

    within '.actions' do
      expect(page).to_not have_link 'Criar Estado'
    end
  end

  scenario 'update a state' do
    rs = State.make!(:rs)

    navigate 'Geral > Parâmetros > Endereços > Estados'

    click_link 'Rio Grande do Sul'

    fill_in 'Nome', :with => 'Rio Grande do Norte'

    click_button 'Salvar'

    expect(page).to have_notice 'Estado editado com sucesso.'

    click_link 'Rio Grande do Norte'

    expect(page).to have_field 'Nome', :with => 'Rio Grande do Norte'
  end

  scenario 'destroy a state' do
    rs = State.make!(:rs)

    navigate 'Geral > Parâmetros > Endereços > Estados'

    click_link 'Rio Grande do Sul'

    click_link 'Apagar'

    expect(page).to have_notice 'Estado apagado com sucesso.'

    expect(page).to_not have_content 'Rio Grande do Sul'
    expect(page).to_not have_content 'RS'
  end
end
