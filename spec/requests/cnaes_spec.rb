# encoding: utf-8
require 'spec_helper'

feature "Cnaes" do
  background do
    sign_in
  end

  scenario 'create a new cnae' do
    RiskDegree.make!(:leve)

    navigate 'Outros > CNAES'

    click_link 'Criar CNAE'

    fill_in 'Descrição', :with => 'Condomínios prediais'
    fill_in 'Código', :with => '8112500'
    fill_modal 'Grau de risco', :with => 'Leve'

    click_button 'Salvar'

    expect(page).to have_notice 'CNAE criado com sucesso.'

    click_link 'Condomínios prediais'

    expect(page).to have_field 'Código', :with => '8112500'
    expect(page).to have_field 'Descrição', :with => 'Condomínios prediais'
    expect(page).to have_field 'Grau de risco', :with => 'Leve'
  end

  scenario 'update an existent cnae' do
    RiskDegree.make!(:medio)
    Cnae.make!(:aluguel)

    navigate 'Outros > CNAES'

    click_link 'Aluguel de outras máquinas'

    fill_in 'Descrição', :with => 'Comércio varejista de bebidas'
    fill_in 'Código', :with => '4723700'
    fill_modal 'Grau de risco', :with => 'Médio'

    click_button 'Salvar'

    expect(page).to have_notice 'CNAE editado com sucesso.'

    click_link 'Comércio varejista de bebidas'

    expect(page).to have_field 'Código', :with => '4723700'
    expect(page).to have_field 'Descrição', :with => 'Comércio varejista de bebidas'
    expect(page).to have_field 'Grau de risco', :with => 'Médio'
  end

  scenario 'destroy an existent cnae' do
    Cnae.make!(:aluguel)

    navigate 'Outros > CNAES'

    click_link 'Aluguel de outras máquinas'

    click_link 'Apagar'

    expect(page).to have_notice 'CNAE apagado com sucesso.'

    expect(page).to_not have_content 'Aluguel de outras máquinas'
  end
end
