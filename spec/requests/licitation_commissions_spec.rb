# encoding: utf-8
require 'spec_helper'

feature "LicitationCommissions" do
  background do
    sign_in
  end

  scenario 'create a new licitation_commission' do
    RegulatoryAct.make!(:sopa)
    Person.make!(:wenderson)

    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    within_tab 'Dados gerais' do
      select 'Especial', :from => 'Tipo de comissão'

      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

      page.should have_field 'Ato regulamentador', :with => '1234'

      page.should have_disabled_field 'Data da publicação do ato'
      page.should have_field 'Data da publicação do ato', :with => '02/01/2012'

      fill_in 'Data da nomeação', :with => '20/03/2012'
      fill_in 'Data da expiração', :with => '22/03/2012'
      fill_in 'Data da exoneração', :with => '25/03/2012'
      fill_in 'Descrição e finalidade da comissão', :with => 'descrição'
    end

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Autoridade', :with => 'Wenderson Malheiros'
      select 'Advogado', :from => 'Cargo'
      fill_in 'Registro da classe', :with => '123456'
    end

    click_button 'Criar Comissão de Licitação'

    page.should have_notice 'Comissão de Licitação criada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_select 'Tipo de comissão', :selected => 'Especial'
      page.should have_field 'Data da nomeação', :with => '20/03/2012'
      page.should have_field 'Data da expiração', :with => '22/03/2012'
      page.should have_field 'Data da exoneração', :with => '25/03/2012'
      page.should have_field 'Descrição e finalidade da comissão', :with => 'descrição'
    end

    within_tab 'Responsáveis' do
      page.should have_field 'Autoridade', :with => 'Wenderson Malheiros'
      page.should have_select 'Cargo', :selected => 'Advogado'
      page.should have_field 'Registro da classe', :with => '123456'
    end
  end

  scenario 'update an existent licitation_commission' do
    RegulatoryAct.make!(:medida_provisoria)
    LicitationCommission.make!(:comissao)
    Person.make!(:sobrinho)

    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      select 'Pregão', :from => 'Tipo de comissão'

      fill_modal 'Ato regulamentador', :with => '8901', :field => 'Número'

      page.should have_field 'Ato regulamentador', :with => '8901'

      page.should have_disabled_field 'Data da publicação do ato'
      page.should have_field 'Data da publicação do ato', :with => '02/01/2013'

      fill_in 'Data da nomeação', :with => '20/03/2013'
      fill_in 'Data da expiração', :with => '22/03/2013'
      fill_in 'Data da exoneração', :with => '25/03/2013'
      fill_in 'Descrição e finalidade da comissão', :with => 'nova descrição'
    end

    within_tab 'Responsáveis' do
      click_button 'Remover'

      click_button 'Adicionar Responsável'

      fill_modal 'Autoridade', :with => 'Gabriel Sobrinho'
      select 'Prefeito municipal', :from => 'Cargo'
    end

    click_button 'Atualizar Comissão de Licitação'

    page.should have_notice 'Comissão de Licitação editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Dados gerais' do
      page.should have_select 'Tipo de comissão', :selected => 'Pregão'
      page.should have_field 'Data da nomeação', :with => '20/03/2013'
      page.should have_field 'Data da expiração', :with => '22/03/2013'
      page.should have_field 'Data da exoneração', :with => '25/03/2013'
      page.should have_field 'Descrição e finalidade da comissão', :with => 'nova descrição'
    end

    within_tab 'Responsáveis' do
      page.should_not have_field 'Autoridade', :with => 'Wenderson Malheiros'

      page.should have_field 'Autoridade', :with => 'Gabriel Sobrinho'
      page.should have_select 'Cargo', :selected => 'Prefeito municipal'
    end
  end

  scenario 'destroy an existent licitation_commission' do
    licitation_commission = LicitationCommission.make!(:comissao)
    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    within_records do
      page.find('a').click
    end

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Comissão de Licitação apagada com sucesso.'

    page.should_not have_link "#{licitation_commission.id}"
  end

  scenario 'should get the CPF number when selecting individual' do
    Person.make!(:wenderson)

    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Autoridade', :with => 'Wenderson Malheiros'

      page.should have_disabled_field 'CPF'
      page.should have_field 'CPF', :with => '003.149.513-34'

      clear_modal 'Autoridade'
      page.should have_disabled_field 'CPF'
      page.should have_field 'CPF', :with => ''
    end
  end

  scenario 'should enable/disable class_register field depending on selected role' do
    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      select 'Prefeito municipal', :from => 'Cargo'
      page.should have_disabled_field 'Registro da classe'

      select 'Secretário de finanças', :from => 'Cargo'
      page.should have_disabled_field 'Registro da classe'

      select 'Secretário de administração', :from => 'Cargo'
      page.should have_disabled_field 'Registro da classe'

      select 'Diretor de compras e licitações', :from => 'Cargo'
      page.should have_disabled_field 'Registro da classe'

      select 'Chefe do setor de compras e licitações', :from => 'Cargo'
      page.should have_disabled_field 'Registro da classe'

      select 'Advogado', :from => 'Cargo'
      page.should_not have_disabled_field 'Registro da classe'
    end
  end

  scenario "should clean the class_register when value selected for role is not lawyer" do
    LicitationCommission.make!(:comissao)

    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    within_records do
      page.find('a').click
    end

    within_tab 'Responsáveis' do
      page.should have_select 'Cargo', :selected => 'Advogado'
      page.should have_field 'Registro da classe', :with => '123457'

      select 'Prefeito municipal', :from => 'Cargo'
    end

    click_button 'Atualizar Comissão de Licitação'

    page.should have_notice 'Comissão de Licitação editada com sucesso.'

    within_records do
      page.find('a').click
    end

    within_tab 'Responsáveis' do
      page.should have_select 'Cargo', :selected => 'Prefeito municipal'
      page.should have_disabled_field 'Registro da classe'
      page.should have_field 'Registro da classe', :with => ''
    end
  end

  scenario 'asserting that duplicated individuals on responsibles can not be saved' do
    RegulatoryAct.make!(:sopa)
    Person.make!(:wenderson)

    click_link 'Contabilidade'

    click_link 'Comissões de Licitação'

    click_link 'Criar Comissão de Licitação'

    within_tab 'Dados gerais' do
      select 'Especial', :from => 'Tipo de comissão'

      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'

      page.should have_field 'Ato regulamentador', :with => '1234'

      page.should have_disabled_field 'Data da publicação do ato'
      page.should have_field 'Data da publicação do ato', :with => '02/01/2012'

      fill_in 'Data da nomeação', :with => '20/03/2012'
      fill_in 'Data da expiração', :with => '22/03/2012'
      fill_in 'Data da exoneração', :with => '25/03/2012'
      fill_in 'Descrição e finalidade da comissão', :with => 'descrição'
    end

    within_tab 'Responsáveis' do
      click_button 'Adicionar Responsável'

      fill_modal 'Autoridade', :with => 'Wenderson Malheiros'
      select 'Advogado', :from => 'Cargo'
      fill_in 'Registro da classe', :with => '123456'

      click_button 'Adicionar Responsável'

      within '.responsible:last' do
        fill_modal 'Autoridade', :with => 'Wenderson Malheiros'
        select 'Prefeito municipal', :from => 'Cargo'
      end
    end

    click_button 'Criar Comissão de Licitação'

    within_tab 'Responsáveis' do
      page.should have_content 'já está em uso'
    end
  end
end
