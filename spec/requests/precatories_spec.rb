# encoding: utf-8
require 'spec_helper'

feature "Precatories" do
  background do
    sign_in
  end

  scenario 'create a new precatory' do
    Provider.make!(:wenderson_sa)
    precatory_type = PrecatoryType.make!(:tipo_de_precatorio_ativo)

    click_link 'Contabilidade'

    click_link 'Precatórios'

    click_link 'Criar Precatório'

    within_tab 'Principal' do
      fill_in 'Número do precatório', :with => '123456'
      fill_modal 'Beneficiário', :field => 'CRC', :with => '456789'
      fill_in 'Número da ação', :with => '001.111.2222/2012'
      fill_mask 'Data do precatório', :with => '10/05/2012'
      fill_mask 'Data da decisão judicial', :with => '05/01/2012'
      fill_mask 'Data da apresentação', :with => '10/01/2012'
      fill_modal 'Tipo', :field => 'Descrição', :with => 'Precatórios Alimentares'
      fill_in 'Histórico', :with => 'Histórico'
    end

    click_button 'Salvar'

    page.should have_notice 'Precatório criado com sucesso.'

    last_precatory = Precatory.last

    within_records do
      click_link last_precatory.to_s
    end

    page.should have_field 'Número do precatório', :with => '123456'
    page.should have_field 'Beneficiário', :with => 'Wenderson Malheiros'
    page.should have_field 'Número da ação', :with => '001.111.2222/2012'
    page.should have_field 'Data do precatório', :with => '10/05/2012'
    page.should have_field 'Data da decisão judicial', :with => '05/01/2012'
    page.should have_field 'Data da apresentação', :with => '10/01/2012'
    page.should have_field 'Tipo', :with => "#{precatory_type}"
    page.should have_field 'Histórico', :with => 'Histórico'
  end

  scenario 'update an existent precatory' do
    precatorio = Precatory.make!(:precatorio)
    Provider.make!(:sobrinho_sa)
    precatory_type = PrecatoryType.make!(:ordinario_demais_casos)

    click_link 'Contabilidade'

    click_link 'Precatórios'

    within_records do
      click_link precatorio.to_s
    end

    within_tab 'Principal' do
      fill_in 'Número do precatório', :with => '123455'
      fill_modal 'Beneficiário', :field => 'CRC', :with => '123456'
      fill_in 'Número da ação', :with => '002.111.2222/2012'
      fill_mask 'Data do precatório', :with => '09/05/2012'
      fill_mask 'Data da decisão judicial', :with => '06/01/2012'
      fill_mask 'Data da apresentação', :with => '11/01/2012'
      fill_modal 'Tipo', :field => 'Descrição', :with => 'Ordinário - Demais Casos'
      fill_in 'Histórico', :with => 'Histórico atualizado'
    end

    click_button 'Salvar'

    page.should have_notice 'Precatório editado com sucesso.'

    within_records do
      click_link precatorio.to_s
    end

    page.should have_field 'Número do precatório', :with => '123455'
    page.should have_field 'Beneficiário', :with => 'Gabriel Sobrinho'
    page.should have_field 'Número da ação', :with => '002.111.2222/2012'
    page.should have_field 'Data do precatório', :with => '09/05/2012'
    page.should have_field 'Data da decisão judicial', :with => '06/01/2012'
    page.should have_field 'Data da apresentação', :with => '11/01/2012'
    page.should have_field 'Tipo', :with => "#{precatory_type}"
    page.should have_field 'Histórico', :with => 'Histórico atualizado'
  end

  scenario 'destroy an existent precatory' do
    precatory = Precatory.make!(:precatorio)

    click_link 'Contabilidade'

    click_link 'Precatórios'

    within_records do
      click_link precatory.to_s
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Precatório apagado com sucesso.'

    page.should_not have_content '1234/2012'
    page.should_not have_content "001.456.1234/2009"
    page.should_not have_content 'Wenderson Malheiros'
    page.should_not have_content '01/01/2012'
    page.should_not have_content '30/06/2011'
    page.should_not have_content '31/12/2011'
    page.should_not have_content 'precatory_type'
    page.should_not have_content "Precatório Expedido conforme decisão do STJ"
  end
end
