# encoding: utf-8
require 'spec_helper'

feature "RiskDegrees" do
  background do
    sign_in
  end

  scenario 'create a new risk_degree, update and destroy an existing' do
    navigate 'Comum > Pessoas > Auxiliar > Grau de Riscos'

    click_link 'Criar Grau de Risco'

    fill_in 'Nível', :with => '1'
    fill_in 'Nome', :with => 'Médio'

    click_button 'Salvar'

    expect(page).to have_notice 'Grau de Risco criado com sucesso.'

    click_link 'Médio'

    expect(page).to have_field 'Nível', :with => "1"
    expect(page).to have_field 'Nome', :with => "Médio"
    
    fill_in 'Nível', :with => '2'
    fill_in 'Nome', :with => 'Muito Grave'

    click_button 'Salvar'

    expect(page).to have_notice 'Grau de Risco editado com sucesso.'

    click_link 'Muito Grave'

    expect(page).to have_field 'Nível', :with => "2"
    expect(page).to have_field 'Nome', :with => "Muito Grave"

    click_link 'Apagar'

    expect(page).to have_notice 'Grau de Risco apagado com sucesso.'

    expect(page).to_not have_content 'Muito Grave'
  end

  scenario 'index with columns at the index' do
    RiskDegree.make!(:grave)

    navigate 'Comum > Pessoas > Auxiliar > Grau de Riscos'

    within_records do
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Nível'

      within 'tbody tr' do
        expect(page).to have_content 'Grave'
        expect(page).to have_content '3'
      end
    end
  end
end
