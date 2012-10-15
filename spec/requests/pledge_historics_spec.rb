# encoding: utf-8
require 'spec_helper'

feature "PledgeHistorics" do
  background do
    sign_in
  end

  scenario 'create a new pledge_historic' do
    Descriptor.make!(:detran_2012)

    navigate 'Outros > Contabilidade > Execução > Empenho > Históricos de Empenho'

    click_link 'Criar Histórico de Empenho'

    fill_modal 'Descritor', :with => '2012', :field => 'Exercício'
    fill_in 'Descrição', :with => 'Mensal'

    click_button 'Salvar'

    expect(page).to have_notice 'Histórico de Empenho criado com sucesso.'

    click_link 'Mensal'

    expect(page).to have_field 'Descritor', :with => '2012 - Detran'
    expect(page).to have_field 'Descrição', :with => 'Mensal'
  end

  scenario 'update an existent pledge_historic' do
    PledgeHistoric.make!(:semestral)
    Descriptor.make!(:secretaria_de_educacao_2013)

    navigate 'Outros > Contabilidade > Execução > Empenho > Históricos de Empenho'

    click_link 'Semestral'

    fill_in 'Descrição', :with => 'Anual'
    fill_modal 'Descritor', :with => '2013', :field => 'Exercício'

    click_button 'Salvar'

    expect(page).to have_notice 'Histórico de Empenho editado com sucesso.'

    click_link 'Anual'

    expect(page).to have_field 'Descrição', :with => 'Anual'
    expect(page).to have_field 'Descritor', :with => '2013 - Secretaria de Educação'
  end

  scenario 'destroy an existent pledge_historic' do
    PledgeHistoric.make!(:semestral)

    navigate 'Outros > Contabilidade > Execução > Empenho > Históricos de Empenho'

    click_link 'Semestral'

    click_link 'Apagar'

    expect(page).to have_notice 'Histórico de Empenho apagado com sucesso.'

    expect(page).to_not have_content 'Semestral'
    expect(page).to_not have_content 'Detran'
  end
end
