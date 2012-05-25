# encoding: utf-8
require 'spec_helper'

feature "Creditors" do
  background do
    sign_in
  end

  scenario 'create a new creditor when people is special entry' do
    Person.make!(:mateus)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Mateus', :field => 'Nome'

    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Mateus Lorandi'

    page.should have_field 'Pessoa', :with => 'Mateus Lorandi'
  end

  scenario 'create a new creditor when people is a company' do
    Person.make!(:nohup)
    Cnae.make!(:varejo)
    CompanySize.make!(:micro_empresa)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Nohup', :field => 'Nome'

    within_tab 'Principal' do
      fill_modal 'Porte da empressa', :with => 'Microempresa', :field => 'Nome'
      check 'Optante pelo simples'

      fill_modal 'CNAE principal', :with => '4712100', :field => 'Código'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Nohup'

    page.should have_field 'Pessoa', :with => 'Nohup'

    within_tab 'Principal' do
      page.should have_field 'Porte da empressa', :with => 'Microempresa'
      page.should have_checked_field 'Optante pelo simples'
      page.should have_field 'CNAE principal', :with => 'Comércio varejista de mercadorias em geral'
    end
  end

  scenario 'create a new creditor when people is individual' do
    Person.make!(:sobrinho)
    OccupationClassification.make!(:armed_forces)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Criar Credor'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho', :field => 'Nome'

    within_tab 'Principal' do
      fill_modal 'CBO', :with => 'MEMBROS DAS FORÇAS ARMADAS', :field => 'Nome'
      check 'Admnistração pública municipal'
      check 'Autônomo'
      fill_in 'PIS/PASEP', :with => '123456'
      fill_in 'Data do PIS/PASEP', :with => '05/04/2012'
      fill_in 'Início do contrato', :with => '05/04/2012'
    end
    click_button 'Salvar'

    page.should have_notice 'Credor criado com sucesso.'

    click_link 'Gabriel Sobrinho'

    page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'

    within_tab 'Principal' do
      page.should have_field 'CBO', :with => '01 - MEMBROS DAS FORÇAS ARMADAS'
      page.should have_checked_field 'Admnistração pública municipal'
      page.should have_checked_field 'Autônomo'
      page.should have_field 'PIS/PASEP', :with => '123456'
      page.should have_field 'Início do contrato', :with => '05/04/2012'
    end
  end

  scenario 'update a creditor when people is special entry' do
    Creditor.make!(:mateus)
    Person.make!(:sobrinho, :personable => SpecialEntry.make!(:especial))

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Mateus Lorandi'

    fill_modal 'Pessoa', :with => 'Gabriel Sobrinho', :field => 'Nome'

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Gabriel Sobrinho'

    page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
  end

  scenario 'update a creditor when people is a company' do
    Creditor.make!(:nohup)
    Cnae.make!(:aluguel)
    CompanySize.make!(:empresa_de_grande_porte)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Nohup'

    fill_modal 'Pessoa', :with => 'Nohup', :field => 'Nome'

    within_tab 'Principal' do
      fill_modal 'Porte da empressa', :with => 'Empresa de grande porte', :field => 'Nome'
      uncheck 'Optante pelo simples'

      fill_modal 'CNAE principal', :with => '7739099', :field => 'Código'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Nohup'

    page.should have_field 'Pessoa', :with => 'Nohup'

    within_tab 'Principal' do
      page.should have_field 'Porte da empressa', :with => 'Empresa de grande porte'
      page.should have_unchecked_field 'Optante pelo simples'
      page.should have_field 'CNAE principal', :with => 'Aluguel de outras máquinas'
    end
  end

  scenario 'update a creditor when people is individual' do
    Creditor.make!(:sobrinho)
    Person.make!(:wenderson)
    OccupationClassification.make!(:engineer)

    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Gabriel Sobrinho'

    fill_modal 'Pessoa', :with => 'Wenderson Malheiros', :field => 'Nome'

    within_tab 'Principal' do
      fill_modal 'CBO', :with => 'Engenheiro', :field => 'Nome'
      fill_in 'PIS/PASEP', :with => '6789'
      fill_mask 'Início do contrato', :with => '05/04/2011'
    end

    click_button 'Salvar'

    page.should have_notice 'Credor editado com sucesso.'

    click_link 'Wenderson Malheiros'

    page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'

    within_tab 'Principal' do
      page.should have_field 'CBO', :with => '214 - Engenheiro'
      page.should have_unchecked_field 'Admnistração pública municipal'
      page.should have_unchecked_field 'Autônomo'
      page.should have_field 'PIS/PASEP', :with => '6789'
      page.should have_field 'Início do contrato', :with => '05/04/2011'
    end
  end

  scenario 'destroy an existent creditor' do
    Creditor.make!(:nohup)
    click_link 'Cadastros Diversos'

    click_link 'Credores'

    click_link 'Nohup'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Credor apagado com sucesso.'

    page.should_not have_content 'Nohup'
    page.should_not have_content 'Microempresa'
  end
end
