# encoding: utf-8
require 'spec_helper'

feature "PledgeHistorics" do
  background do
    sign_in
  end

  scenario 'create a new pledge_historic' do
    Entity.make!(:detran)

    click_link 'Contabilidade'

    click_link 'Históricos de Empenho'

    click_link 'Criar Histórico de Empenho'

    fill_in 'Descrição', :with => 'Mensal'
    fill_modal 'Entidade', :with => 'Detran'
    fill_mask 'Exercício', :with => '2012'

    click_button 'Salvar'

    page.should have_notice 'Histórico de Empenho criado com sucesso.'

    click_link 'Mensal'

    page.should have_field 'Descrição', :with => 'Mensal'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_field 'Exercício', :with => '2012'
  end

  scenario 'update an existent pledge_historic' do
    PledgeHistoric.make!(:semestral)
    Entity.make!(:secretaria_de_educacao)

    click_link 'Contabilidade'

    click_link 'Históricos de Empenho'

    click_link 'Semestral'

    fill_in 'Descrição', :with => 'Anual'
    fill_modal 'Entidade', :with => 'Secretaria de Educação'
    fill_mask 'Exercício', :with => '2013'

    click_button 'Salvar'

    page.should have_notice 'Histórico de Empenho editado com sucesso.'

    click_link 'Anual'

    page.should have_field 'Descrição', :with => 'Anual'
    page.should have_field 'Entidade', :with => 'Secretaria de Educação'
    page.should have_field 'Exercício', :with => '2013'
  end

  scenario 'destroy an existent pledge_historic' do
    PledgeHistoric.make!(:semestral)

    click_link 'Contabilidade'

    click_link 'Históricos de Empenho'

    click_link 'Semestral'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Histórico de Empenho apagado com sucesso.'

    page.should_not have_content 'Semestral'
    page.should_not have_content 'Detran'
  end
end
