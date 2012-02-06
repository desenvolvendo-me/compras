# encoding: utf-8
require 'spec_helper'

feature "Organograms" do
  background do
    sign_in
  end

  scenario 'create a new organogram' do
    ConfigurationOrganogram.make!(:detran_sopa)
    AdministrationType.make!(:publica)
    Address.make!(:general)
    Employee.make!(:sobrinho)
    AdministractiveAct.make!(:sopa)

    click_link 'Cadastros Diversos'

    click_link 'Organogramas'

    click_link 'Criar Organograma'

    within_tab 'Informações' do
      fill_in 'Nome', :with => 'Secretaria de Educação'
      fill_in 'Sigla', :with => 'SEMUEDU'
      fill_modal 'Configuração de organograma', :with => 'Configuração do Detran'
      fill_in 'Organograma', :with => '02.00'
      select 'Analítico', :from => 'Tipo'
      fill_in 'Código TCE', :with => '051'
      fill_modal 'Tipo de administração', :with => 'Pública'
      fill_in 'Área de atuação', :with => 'Desenvolvimento Educacional'
    end

    within_tab 'Endereços' do
      fill_modal 'Logradouro', :with => 'Girassol'
      fill_modal 'Bairro', :with => 'São Francisco'
      fill_in 'CEP', :with => "33400-500"
    end

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
      fill_modal 'Ato administrativo', :with => '1234', :field => 'Número'
      fill_in 'Data de início', :with => '01/02/2012'
      fill_in 'Data de término', :with => '10/02/2012'
      select 'Ativo', :from => 'Status'
    end

    click_button 'Criar Organograma'

    page.should have_notice 'Organograma criado com sucesso.'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      page.should have_field 'Nome', :with => 'Secretaria de Educação'
      page.should have_field 'Sigla', :with => 'SEMUEDU'
      page.should have_field 'Configuração de organograma', :with => 'Configuração do Detran'
      page.should have_field 'Organograma', :with => '02.00'
      page.should have_select 'Tipo', :selected => 'Analítico'
      page.should have_field 'Código TCE', :with => '051'
      page.should have_field 'Tipo de administração', :with => 'Pública'
      page.should have_field 'Área de atuação', :with => 'Desenvolvimento Educacional'
    end

    within_tab 'Endereços' do
      page.should have_field 'Logradouro', :with => 'Girassol'
      page.should have_field 'Bairro', :with => 'São Francisco'
      page.should have_field 'CEP', :with => '33400-500'
    end

    within_tab 'Responsáveis' do
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Ato administrativo', :with => '1234'
      page.should have_field 'Data de início', :with => '01/02/2012'
      page.should have_field 'Data de término', :with => '10/02/2012'
      page.should have_select 'Status', :selected => 'Ativo'
    end
  end

  scenario 'update an existent organogram' do
    Organogram.make!(:secretaria_de_educacao)
    Address.make!(:education)
    AdministrationType.make!(:executivo)
    Employee.make!(:wenderson)
    AdministractiveAct.make!(:emenda)

    click_link 'Cadastros Diversos'

    click_link 'Organogramas'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      fill_in 'Nome', :with => 'Secretaria de Transporte'
      fill_in 'Sigla', :with => 'SEMUTRA'
      fill_modal 'Configuração de organograma', :with => 'Configuração do Detran'
      fill_in 'Organograma', :with => '02.11'
      select 'Sintético', :from => 'Tipo'
      fill_in 'Código TCE', :with => '081'
      fill_modal 'Tipo de administração', :with => 'Emenda constitucional'
      fill_in 'Área de atuação', :with => 'Desenvolvimento de Transporte'
    end

    within_tab 'Endereços' do
      fill_modal 'Logradouro', :with => 'Amazonas'
      fill_modal 'Bairro', :with => 'Portugal'
      fill_in 'CEP', :with => '33600-500'
    end

    within_tab 'Responsáveis' do
      fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Ato administrativo', :with => '4567', :field => 'Número'
      fill_in 'Data de início', :with => '01/02/2012'
      fill_in 'Data de término', :with => '10/02/2012'
      select 'Inativo', :from => 'Status'
    end

    click_button 'Atualizar Organograma'

    page.should have_notice 'Organograma editado com sucesso.'

    click_link 'Secretaria de Transporte'

    within_tab 'Informações' do
      page.should have_field 'Nome', :with => 'Secretaria de Transporte'
      page.should have_field 'Sigla', :with => 'SEMUTRA'
      page.should have_field 'Configuração de organograma', :with => 'Configuração do Detran'
      page.should have_field 'Organograma', :with => '02.11'
      page.should have_select 'Tipo', :selected => 'Sintético'
      page.should have_field 'Código TCE', :with => '081'
      page.should have_field 'Tipo de administração', :with => 'Emenda constitucional'
      page.should have_field 'Área de atuação', :with => 'Desenvolvimento de Transporte'
    end

    within_tab 'Endereços' do
      page.should have_field 'Logradouro', :with => 'Amazonas'
      page.should have_field 'Bairro', :with => 'Portugal'
      page.should have_field 'CEP', :with => '33600-500'
    end

    within_tab 'Responsáveis' do
      page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
      page.should have_field 'Ato administrativo', :with => '4567'
      page.should have_field 'Data de início', :with => '01/02/2012'
      page.should have_field  'Data de término', :with => '10/02/2012'
      page.should have_select 'Status', :selected => 'Inativo'
    end
  end

  scenario 'remove a responsible' do
    Organogram.make!(:secretaria_de_educacao)

    click_link 'Cadastros Diversos'

    click_link 'Organogramas'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      click_button 'Remover Responsável'
    end

    click_button 'Atualizar Organograma'

    page.should have_notice 'Organograma editado com sucesso.'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      page.should_not have_field 'Responsável', :with => 'Wenderson Malheiros'
      page.should_not have_field 'Ato administrativo', :with => '4567'
      page.should_not have_field 'Data de início', :with => '01/02/2012'
      page.should_not have_field  'Data de término', :with => '10/02/2012'
      page.should_not have_select 'Status', :selected => 'Inativo'
    end
  end

  scenario 'destroy an existent organogram' do
    Organogram.make!(:secretaria_de_educacao)

    click_link 'Cadastros Diversos'

    click_link 'Organogramas'

    click_link 'Secretaria de Educação'

    click_link 'Apagar Secretaria de Educação', :confirm => true

    page.should have_notice 'Organograma apagado com sucesso.'

    page.should_not have_content 'Secretaria de Educação'
    page.should_not have_content 'Configuração do Detran'
    page.should_not have_content '02.00'
    page.should_not have_content '051'
    page.should_not have_content 'SEMUEDU'
    page.should_not have_content 'Pública'
    page.should_not have_content 'Desenvolvimento Educacional'
  end
end
