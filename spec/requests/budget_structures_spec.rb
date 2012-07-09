# encoding: utf-8
require 'spec_helper'

feature "BudgetStructure" do
  background do
    sign_in
  end

  scenario 'create a new budget structure' do
    BudgetStructureConfiguration.make!(:detran_sopa)
    AdministrationType.make!(:publica)
    Address.make!(:general)
    Employee.make!(:sobrinho)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Criar Estrutura Orçamentaria'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      select 'Sintético', :from => 'Tipo'

      within_modal 'Nível' do
        page.should have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        page.should have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Orgão'
      end

      fill_in 'Código', :with => '1'
      page.should have_field 'Estrutura orçamentaria', :with => '1'
      fill_in 'Código TCE', :with => '051'
      fill_in 'Descrição', :with => 'Secretaria de Educação'
      fill_in 'Sigla', :with => 'SEMUEDU'
      fill_modal 'Tipo de administração', :with => 'Pública', :field => 'Descrição'
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
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      fill_in 'Data de início', :with => '01/02/2012'
      fill_in 'Data de término', :with => '10/02/2012'
      select 'Ativo', :from => 'Status'
    end

    click_button 'Salvar'

    page.should have_notice 'Estrutura Orçamentaria criado com sucesso.'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      page.should have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
      page.should have_select 'Tipo', :selected => 'Sintético'
      page.should have_field 'Nível', :with => '1 - Orgão'
      page.should have_field 'Código', :with => '1'
      page.should have_field 'Estrutura orçamentaria', :with => '1'
      page.should have_field 'Código TCE', :with => '051'
      page.should have_field 'Descrição', :with => 'Secretaria de Educação'
      page.should have_field 'Sigla', :with => 'SEMUEDU'
      page.should have_field 'Tipo de administração', :with => 'Pública'
      page.should have_field 'Área de atuação', :with => 'Desenvolvimento Educacional'
    end

    within_tab 'Endereços' do
      page.should have_field 'Logradouro', :with => 'Rua Girassol'
      page.should have_field 'Bairro', :with => 'São Francisco'
      page.should have_field 'CEP', :with => '33400-500'
    end

    within_tab 'Responsáveis' do
      page.should have_field 'Responsável', :with => 'Gabriel Sobrinho'
      page.should have_field 'Ato regulamentador', :with => '1234'
      page.should have_field 'Data de início', :with => '01/02/2012'
      page.should have_field 'Data de término', :with => '10/02/2012'
      page.should have_select 'Status', :selected => 'Ativo'
    end
  end

  scenario 'update an existent budget structure' do
    BudgetStructure.make!(:secretaria_de_educacao)
    Address.make!(:education)
    AdministrationType.make!(:executivo)
    Employee.make!(:wenderson)
    RegulatoryAct.make!(:emenda)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      within_modal 'Nível' do
        page.should have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        page.should have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Orgão'
      end
      fill_in 'Código', :with => '2'
      page.should have_field 'Estrutura orçamentaria', :with => '2'
      fill_in 'Código TCE', :with => '081'
      fill_in 'Descrição', :with => 'Secretaria de Transporte'
      fill_in 'Sigla', :with => 'SEMUTRA'
      fill_modal 'Tipo de administração', :with => 'Executivo', :field => 'Descrição'
      fill_in 'Área de atuação', :with => 'Desenvolvimento de Transporte'
    end

    within_tab 'Endereços' do
      fill_modal 'Logradouro', :with => 'Amazonas'
      fill_modal 'Bairro', :with => 'Portugal'
      fill_in 'CEP', :with => '33600-500'
    end

    within_tab 'Responsáveis' do
      fill_modal 'Responsável', :with => '12903412', :field => 'Matrícula'
      fill_modal 'Ato regulamentador', :with => '4567', :field => 'Número'
      fill_in 'Data de início', :with => '01/02/2012'
      fill_in 'Data de término', :with => '10/02/2012'
      select 'Inativo', :from => 'Status'
    end

    click_button 'Salvar'

    page.should have_notice 'Estrutura Orçamentaria editado com sucesso.'

    click_link 'Secretaria de Transporte'

    within_tab 'Informações' do
      page.should have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
      page.should have_select 'Tipo', :selected => 'Sintético'
      page.should have_field 'Nível', :with => '1 - Orgão'
      page.should have_field 'Código', :with => '2'
      page.should have_field 'Estrutura orçamentaria', :with => '2'
      page.should have_field 'Código TCE', :with => '081'
      page.should have_field 'Descrição', :with => 'Secretaria de Transporte'
      page.should have_field 'Sigla', :with => 'SEMUTRA'
      page.should have_field 'Tipo de administração', :with => 'Executivo'
      page.should have_field 'Área de atuação', :with => 'Desenvolvimento de Transporte'
    end

    within_tab 'Endereços' do
      page.should have_field 'Logradouro', :with => 'Avenida Amazonas'
      page.should have_field 'Bairro', :with => 'Portugal'
      page.should have_field 'CEP', :with => '33600-500'
    end

    within_tab 'Responsáveis' do
      page.should have_field 'Responsável', :with => 'Wenderson Malheiros'
      page.should have_field 'Ato regulamentador', :with => '4567'
      page.should have_field 'Data de início', :with => '01/02/2012'
      page.should have_field  'Data de término', :with => '10/02/2012'
      page.should have_select 'Status', :selected => 'Inativo'
    end
  end

  scenario 'assert that javascript return parent mask when budget structure that have a parent' do
    BudgetStructure.make!(:secretaria_de_desenvolvimento)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Desenvolvimento'

    within_tab 'Informações' do
      fill_in 'Código', :with => '12'

      page.should have_field 'Estrutura orçamentaria', :with => '1.12'
    end
  end

  scenario 'should not create a new budget structure when already exist a code in the same level and configuration' do
    BudgetStructure.make!(:secretaria_de_educacao)
    BudgetStructureConfiguration.make!(:detran_sopa)
    AdministrationType.make!(:publica)
    Address.make!(:general)
    Employee.make!(:sobrinho)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Criar Estrutura Orçamentaria'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      select 'Sintético', :from => 'Tipo'

      within_modal 'Nível' do
        page.should have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        page.should have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Orgão'
      end

      fill_in 'Código', :with => '1'
      page.should have_field 'Estrutura orçamentaria', :with => '1'
      fill_in 'Código TCE', :with => '051'
      fill_in 'Descrição', :with => 'Secretaria de Educação'
      fill_in 'Sigla', :with => 'SEMUEDU'
      fill_modal 'Tipo de administração', :with => 'Pública', :field => 'Descrição'
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
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      fill_in 'Data de início', :with => '01/02/2012'
      fill_in 'Data de término', :with => '10/02/2012'
      select 'Ativo', :from => 'Status'
    end

    click_button 'Salvar'

    page.should have_content 'já existe um código para este nível desta configuração Estrutura orçamentaria Código TCE'
  end

  scenario 'validating modal of level' do
    BudgetStructure.make!(:secretaria_de_educacao)
    BudgetStructureConfiguration.make!(:secretaria_de_educacao)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      within_modal 'Nível' do
         click_button 'Pesquisar'

         page.should have_content 'Orgão'
         page.should have_content 'Unidade'
         page.should_not have_content 'Nível 1'
         page.should_not have_content 'Nível 2'
      end
    end
  end

  scenario 'validating modal of budget_structure_parent' do
    BudgetStructure.make!(:secretaria_de_educacao)
    BudgetStructure.make!(:secretaria_de_desenvolvimento)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Criar Estrutura Orçamentaria'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      select 'Sintético', :from => 'Tipo'

      within_modal 'Nível' do
        page.should have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        page.should have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Unidade'
      end

      within_modal 'Estrutura orçamentaria superior' do
        page.should have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        page.should have_disabled_field 'Configuração de estrutura orçamentaria'
        page.should have_field 'Nível', :with => '1 - Orgão'
        page.should have_disabled_field 'Nível'

        click_button 'Pesquisar'

        page.should have_content 'Secretaria de Educação'
        page.should_not have_content 'Secretaria de Desenvolvimento'
      end
    end
  end

  scenario 'remove a responsible' do
    BudgetStructure.make!(:secretaria_de_educacao)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      click_button 'Remover Responsável'
    end

    click_button 'Salvar'

    page.should have_notice 'Estrutura Orçamentaria editado com sucesso.'

    click_link 'Secretaria de Educação'

    within_tab 'Responsáveis' do
      page.should_not have_field 'Responsável', :with => 'Wenderson Malheiros'
      page.should_not have_field 'Ato regulamentador', :with => '4567'
      page.should_not have_field 'Data de início', :with => '01/02/2012'
      page.should_not have_field  'Data de término', :with => '10/02/2012'
      page.should_not have_select 'Status', :selected => 'Inativo'
    end
  end

  scenario 'destroy an existent budget structure' do
    BudgetStructure.make!(:secretaria_de_educacao)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Secretaria de Educação'

    click_link 'Apagar', :confirm => true

    page.should have_notice 'Estrutura Orçamentaria apagado com sucesso.'

    page.should_not have_content 'Secretaria de Educação'
    page.should_not have_content 'Configuração do Detran'
    page.should_not have_content '02.00'
    page.should_not have_content '051'
    page.should_not have_content 'SEMUEDU'
    page.should_not have_content 'Pública'
    page.should_not have_content 'Desenvolvimento Educacional'
  end

  scenario 'trying to create an budget structure with duplicated responsibles as the only error to ensure that it will not be saved' do
    BudgetStructureConfiguration.make!(:detran_sopa)
    AdministrationType.make!(:publica)
    Address.make!(:general)
    Employee.make!(:sobrinho)

    navigate_through 'Contabilidade > Orçamento > Estrutura Organizacional > Estruturas Orçamentarias'

    click_link 'Criar Estrutura Orçamentaria'

    within_tab 'Informações' do
      fill_modal 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran', :field => 'Descrição'
      select 'Sintético', :from => 'Tipo'

      within_modal 'Nível' do
        page.should have_field 'Configuração de estrutura orçamentaria', :with => 'Configuração do Detran'
        page.should have_disabled_field 'Configuração de estrutura orçamentaria'
        click_button 'Pesquisar'
        click_record 'Orgão'
      end

      fill_in 'Código', :with => '1'
      page.should have_field 'Estrutura orçamentaria', :with => '1'
      fill_in 'Código TCE', :with => '051'
      fill_in 'Descrição', :with => 'Secretaria de Educação'
      fill_in 'Sigla', :with => 'SEMUEDU'
      fill_modal 'Tipo de administração', :with => 'Pública', :field => 'Descrição'
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
      fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
      fill_in 'Data de início', :with => '01/02/2012'
      fill_in 'Data de término', :with => '10/02/2012'
      select 'Ativo', :from => 'Status'

      click_button 'Adicionar Responsável'

      within 'fieldset:first' do
        fill_modal 'Responsável', :with => '958473', :field => 'Matrícula'
        fill_modal 'Ato regulamentador', :with => '1234', :field => 'Número'
        fill_in 'Data de início', :with => '01/02/2012'
        fill_in 'Data de término', :with => '10/02/2012'
        select 'Ativo', :from => 'Status'
      end
    end

    click_button 'Salvar'

    within_tab 'Responsáveis' do
      page.should have_content 'já está em uso'
    end
  end
end
