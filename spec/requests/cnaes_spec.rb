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

    page.should have_notice 'CNAE criado com sucesso.'

    click_link 'Condomínios prediais'

    page.should have_field 'Código', :with => '8112500'
    page.should have_field 'Descrição', :with => 'Condomínios prediais'
    page.should have_field 'Grau de risco', :with => 'Leve'
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

    page.should have_notice 'CNAE editado com sucesso.'

    click_link 'Comércio varejista de bebidas'

    page.should have_field 'Código', :with => '4723700'
    page.should have_field 'Descrição', :with => 'Comércio varejista de bebidas'
    page.should have_field 'Grau de risco', :with => 'Médio'
  end

  scenario 'destroy an existent cnae' do
    Cnae.make!(:aluguel)

    navigate 'Outros > CNAES'

    click_link 'Aluguel de outras máquinas'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'CNAE apagado com sucesso.'

    page.should_not have_content 'Aluguel de outras máquinas'
  end
end
