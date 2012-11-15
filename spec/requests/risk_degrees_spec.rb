# encoding: utf-8
require 'spec_helper'

feature "RiskDegrees" do
  background do
    sign_in
  end

  scenario 'create a new risk_degree' do
    navigate 'Comum > Pessoas > Auxiliar > Grau de Riscos'

    click_link 'Criar Grau de Risco'

    fill_in 'Nível', :with => '1'
    fill_in 'Nome', :with => 'Médio'

    click_button 'Salvar'

    expect(page).to have_notice 'Grau de Risco criado com sucesso.'

    click_link 'Médio'

    expect(page).to have_field 'Nível', :with => "1"
    expect(page).to have_field 'Nome', :with => "Médio"
  end

  scenario 'update an existent risk_degree' do
    risk_degree = RiskDegree.make!(:leve)

    navigate 'Comum > Pessoas > Auxiliar > Grau de Riscos'

    click_link 'Leve'

    fill_in 'Nome', :with => 'Muito Grave'
    fill_in 'Nível', :with => '4'

    click_button 'Salvar'

    expect(page).to have_notice 'Grau de Risco editado com sucesso.'

    click_link 'Muito Grave'

    expect(page).to have_field 'Nível', :with => "4"
    expect(page).to have_field 'Nome', :with => "Muito Grave"
  end

  scenario 'destroy an existent risk_degree' do
    risk_degree = RiskDegree.make!(:grave)

    navigate 'Comum > Pessoas > Auxiliar > Grau de Riscos'

    click_link 'Grave'

    click_link 'Apagar'

    expect(page).to have_notice 'Grau de Risco apagado com sucesso.'

    expect(page).to_not have_content 'Grave'
  end
end
