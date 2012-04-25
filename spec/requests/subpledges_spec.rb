# encoding: utf-8
require 'spec_helper'

feature "SubPledges" do
  background do
    sign_in
  end

  scenario 'create a new subpledge' do
    Entity.make!(:detran)
    pledge = Pledge.make!(:empenho)
    Creditor.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    fill_modal 'Entidade', :with => 'Detran'
    fill_in 'Ano', :with => '2012'
    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    fill_in 'Número do processo', :with => '1239/2012'
    fill_modal 'Credor *', :with => 'Nohup LTDA.'
    fill_in 'Data *', :with => I18n.l(Date.current)
    fill_in 'Valor *', :with => '1,00'
    fill_in 'Objeto', :with => 'Aquisição de materiais'

    click_button 'Salvar'

    page.should have_notice 'Subempenho criado com sucesso.'

    within_records do
      page.find('a').click
    end

    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_disabled_field 'Credor do empenho'
    page.should have_field 'Credor do empenho', :with => 'Nohup LTDA.'
    page.should have_disabled_field 'Data de emissão'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor do empenho'
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_disabled_field 'Saldo a subempenhar'
    page.should have_field 'Saldo a subempenhar', :with => '9,99'
    page.should have_field 'Ano', :with => '2012'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_field 'Subempenho', :with => '1'
    page.should have_field 'Número do processo', :with => '1239/2012'
    page.should have_field 'Credor *', :with => 'Nohup LTDA.'
    page.should have_field 'Data *', :with => I18n.l(Date.current)
    page.should have_field 'Valor *', :with => '1,00'
    page.should have_field 'Objeto', :with => 'Aquisição de materiais'
  end

  scenario 'should fill modal only to pledge as pledge_type as global or estimated' do
    Pledge.make!(:empenho)
    Pledge.make!(:empenho_ordinario)
    Pledge.make!(:empenho_estimativo)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    within_modal 'Empenho' do
      click_button 'Pesquisar'

      page.should have_content '2012'
      page.should have_content '2011'
      page.should_not have_content '2010'
    end
  end

  scenario 'should fill pledge related fields with fill pledge' do
    pledge = Pledge.make!(:empenho)
    #Entity.make!(:detran)
    #Creditor.make!(:nohup)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link 'Criar Subempenho'

    page.should have_disabled_field 'Credor do empenho'
    page.should have_disabled_field 'Data de emissão'
    page.should have_disabled_field 'Valor do empenho'
    page.should have_disabled_field 'Saldo a subempenhar'

    fill_modal 'Empenho', :with => '2012', :field => 'Exercício'
    page.should have_field 'Credor do empenho', :with => 'Nohup LTDA.'
    page.should have_field 'Data de emissão', :with => I18n.l(Date.current)
    page.should have_field 'Valor do empenho', :with => '9,99'
    page.should have_field 'Saldo a subempenhar', :with => '9,99'
    page.should have_field 'Credor *', :with => 'Nohup LTDA.'
    page.should have_field 'Objeto *', :with => 'Descricao'
    page.should have_field 'Valor *', :with => '9,99'

    clear_modal 'Empenho'
    page.should have_field 'Credor do empenho', :with => ''
    page.should have_field 'Data de emissão', :with => ''
    page.should have_field 'Valor do empenho', :with => ''
    page.should have_field 'Saldo a subempenhar', :with => ''
  end

  scenario 'should have all fields disabled when edit subpledge' do
    pledge = Pledge.make!(:empenho)
    subpledge = Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link "#{subpledge.id}"

    should_not have_button 'Atualizar Anulação de Empenho'

    page.should have_disabled_field 'Entidade'
    page.should have_field 'Entidade', :with => 'Detran'
    page.should have_disabled_field 'Ano'
    page.should have_field 'Ano', :with => '2012'
    page.should have_disabled_field 'Empenho'
    page.should have_field 'Empenho', :with => "#{pledge.id}"
    page.should have_disabled_field 'Número do processo'
    page.should have_field 'Número do processo', :with => '1239/2012'
    page.should have_disabled_field 'Credor'
    page.should have_field 'Credor', :with => 'Nohup LTDA.'
    page.should have_disabled_field 'Data'
    page.should have_field 'Data', :with => I18n.l(Date.current)
    page.should have_disabled_field 'Valor'
    page.should have_field 'Valor', :with => '1,00'
    page.should have_disabled_field 'Objeto'
    page.should have_field 'Objeto', :with => 'Aquisição de material'
  end

  scenario 'should not have a button to destroy an existent pledge' do
    subpledge = Subpledge.make!(:empenho_2012)

    click_link 'Contabilidade'

    click_link 'Subempenhos'

    click_link "#{subpledge.id}"

    page.should_not have_link "Apagar #{subpledge.id}"
  end
end
